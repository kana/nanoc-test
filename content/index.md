---
created_at: 2010-02-05T23:47:29+09:00
---

<%
# TODO: How to share topic rendering?
# TODO: Should use compiled_content of each topic?
# TODO: What information should /index define?  Only parameters?
%>
<% recent_topics.each do |t| %>
  <%= render 'topic', :item => t %>
<% end %>
