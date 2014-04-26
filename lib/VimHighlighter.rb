require 'cgi'
require 'open3'

class VimHighlighter < Nanoc::Filter
  identifier :vim_highlighter
  type :text

  # FIXME: Support 'number' if a code block is declared so.
  def run(content, params={})
    # Assumes that content was filtered by kramdown.
    content
    .gsub(%r[(<pre><code class="language-([a-z]+)">)([^<>]*)(</code></pre>)]m) {
      $1 + highlight(decode_entity_references($3), $2) + $4
    }
  end

  def decode_entity_references(text)
    CGI.unescape_html(text)
  end

  # Notes:
  # - For some reason "-" doesn't work to read from the standard input.
  # - :TOhtml makes a link for each URI, but it's unwanted service.
  # - :TOhtml makes empty <span>s in many cases, but it's invalid result.
  # - For some reason Vim always exits with non-zero status.
  # - Vim can take up to 10 "-c" flags.
  # - :print and :qall! should be run in dedicated "-c"s, because the two
  #   commands will be canceled if a preceding command fails.
  # - Vim 7.4.169 is assumed to run this script.
  def highlight(text, filetype)
    script_basic_setup = <<-'END'
      set encoding=utf-8
      runtime flavors/bootstrap.vim
      syntax enable
    END
    script_local_setup = <<-"END"
      setlocal filetype=#{filetype}
    END
    script_conversion = <<-'END'
      let g:html_ignore_folding = 1
      let g:html_use_css = 1
      let g:html_use_xhtml = 1
      silent! runtime syntax/2html.vim
      % substitute!\c<a\s\+[^<>]*>\([^<>]\{-}\)</a>!\1!ge
      % substitute!\c<span\s\+[^<>]*>\(\_s\{-}\)<\/span>!\1!ge
    END
    script_output = <<-'END'
      /^<pre\(\s[^<>]*\)\?>$/+1,/^<\/pre>$/-1 print
    END
    script_quit = <<-'END'
      qall!
    END

    vim_cmdline =
      %w[vim -u NONE -i NONE -N -e -s] +
      ['-c', script_basic_setup] +
      ['-c', script_local_setup] +
      ['-c', script_conversion] +
      ['-c', script_output] +
      ['-c', script_quit] +
      ['/dev/stdin']
    Open3.popen2(*vim_cmdline) do |stdin, stdout|
      stdin.write(text)
      stdin.close()
      return stdout.read()
    end
  end
end
