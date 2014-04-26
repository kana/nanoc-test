" Assumption: This script is executed by gVim.


function! s:css_property_from(vim_attribute)
  if a:vim_attribute ==# 'bold' || a:vim_attribute ==# 'standout'
    return 'font-weight: bolder;'
  elseif a:vim_attribute ==# 'underline'
    return 'text-decoration: underline;'
  elseif a:vim_attribute ==# 'undercurl'
    return 'border-bottom: thin dashed;'
  elseif a:vim_attribute ==# 'italic'
    return 'font-style: italic;'
  else
    return printf('/* FIXME: Support %s */', a:vim_attribute)
  endif
endfunction


function! s:css_properties_from(vim_attributes)
  let as = split(a:vim_attributes, ',')
  return join(map(as, 's:css_property_from(v:val)'), ' ')
endfunction


function! s:create_css_for_syntax_highlighting()
  " Dump the current configuration of syntax highlighting into the new buffer.
  redir => s
  silent highlight
  redir END
  tabnew
  put =s

  " Remove garbage.
  % substitute/\s\+/ /g
  global/\<cleared\>/delete _
  global/\<links\> \<to\>/delete _
  global/^\l/delete _
  % substitute/ \<c\?term\S\+//g
  % substitute/ \<xxx\>//
  global/^ *$/delete _
  sort

  " CSS'ize.
  % substitute/\<guifg=\(\S\+\)/color: \L\1;/
  % substitute/\<guibg=\(\S\+\)/background-color: \L\1;/
  % substitute/\<guisp=\(\S\+\)/border-color: \L\1;/
  % substitute/\<gui=\(\S\+\)/\=s:css_properties_from(submatch(1))/
  % substitute/^\(\S\+\) \(.*\)$/pre > code .\1 {\2}/
  % substitute/\.Normal\>\zs/, pre/

  " Tidy up.
  setfiletype css
  1
endfunction


silent call s:create_css_for_syntax_highlighting()
