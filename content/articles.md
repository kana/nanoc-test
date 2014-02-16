---
title: Articles
created_at: 2006-12-03T14:48:45+09:00
---


<div class="search-box">
  <form action="http://www.google.com/search" method="get">
    <table summary="Search within this site.">
      <tr>
        <td><input type="text" value="" name="q"/></td>
        <td>
          <input type="hidden" value="whileimautomaton.net" name="sitesearch"/>
          <input type="submit" value="Search in this website"/>
        </td>
      </tr>
    </table>
  </form>
</div>


### Lists of articles

<%
  topics_per_month =
    items
    .select(&:topic?)
    .group_by {|i| i.identifier.match(%r{^(/\d+/\d+/)\d+/$})[1]}
  year_groups =
    topics_per_month
    .group_by {|m, ts| m[0..3]}
%>
<%= render 'lists_of_articles', :topics => items.select(&:topic?) %>


### Legacy topics

* [cereja, alternative shell](/2006/12/cereja/)
* [beatmaniaIIDX 関連](/2005/12/bm2dx)
* [Blackbox for Windows 関連情報](/2004/04/bb4w)
