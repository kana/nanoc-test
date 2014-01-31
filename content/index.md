---
created_at: 2010-02-05T23:47:29+09:00
---

<%
# TODO: How to share topic rendering?
# TODO: Should use compiled_content of each topic?
# TODO: What information should /index define?  Only parameters?

recent_topic_count = 5
recent_topics =
  items
  .select {|i| i.identifier.match %r'^/\d\d\d\d/\d\d/\d\d\d\d\d\d\d\d/$'}
  .sort_by {|i| i[:created_at]}
  .reverse
  .take(recent_topic_count)

%>

<% recent_topics.each do |t| %>
## <%= t[:title] %>
(<%= t[:created_at] %>)
(<%= t[:tags] %>)

<%= t.raw_content %>
<% end %>