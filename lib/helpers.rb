include Nanoc::Helpers::Rendering

class Nanoc::Item
  def topic?
    identifier.match %r'^/\d\d\d\d/\d\d/\d\d\d\d\d\d\d\d/$'
  end
end
