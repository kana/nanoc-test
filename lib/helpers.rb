require 'rss'

include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Rendering

class Nanoc::Item
  def topic?
    identifier.match %r'^/\d\d\d\d/\d\d/\d\d\d\d\d\d\d\d/$'
  end

  def month_view?
    identifier.match %r'^/\d+/\d+/$'
  end

  def uri
    @site.config[:site][:prefix] + path.sub(/\.html$/, '')
  end

  def written_in?(extension)
    self[:extension] == extension
  end
end

def recent_topics
  @recent_topics ||=
    items
    .select(&:topic?)
    .sort_by {|i| i[:created_at]}
    .reverse
    .take(config[:recent_topic_count])
end
