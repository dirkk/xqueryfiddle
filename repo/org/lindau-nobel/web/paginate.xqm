(:~
 : Pagination (...).
 :
 : @author BaseX GmbH 2012, Michael Seiferle
 :)
module namespace _ = "http://lindau-nobel.org/web/paginate";

import module namespace util = 'http://basex.org/modules/web/util';

(:~
 : Generates links for pagination.
 : @param $link target URL
 : @param $onclick ajax call on click
 : @param $current current page
 : @param $total total number of pages
 : @param $pout how many pages to show below and after the current
 :        page
 : @param $params a map containing link parameters in the form {
 :        "KEY" := value, "KEY2":=(values, values)}
 :)
declare function _:paginate(
  $link as xs:string,
  $onclick as xs:string,
  $current as xs:integer,
  $total as xs:integer,
  $pout as xs:integer,
  $params as map(*)){
    let $l := 
      let $params := map:remove($params, "page")
      return
        if (count(map:keys($params)) > 0)
        then util:map-to-params($link, $params) || "&amp;page="
        else util:map-to-params($link, $params)|| "page="
    let $start := if (($current - $pout) > 0) then $current - $pout else 1
    let $end := if (($current + $pout) < $total) then $current + $pout else $total
    return
  <div class="pagination pagination-centered">

    <ul>
    {
        if ($current != 1) then
          if ($start > 3) then
            ( <li><a onclick="{$onclick}" href="{$l}{$current -1}">«</a></li>,
        <li><a onclick="{$onclick}" href="{$l}1">1</a></li>,
        <li class=  "disabled"><a href="#">…</a></li>)
          else
            if ($start = 3) then
            ( <li><a onclick="{$onclick}" href="{$l}{$current -1}">«</a></li>,
        <li><a onclick="{$onclick}" href="{$l}1">1</a></li>,
        <li><a onclick="{$onclick}" href="{$l}2">2</a></li>)
      else
        if ($start = 2) then
        ( <li><a onclick="{$onclick}" href="{$l}{$current -1}">«</a></li>,
          <li><a onclick="{$onclick}" href="{$l}1">1</a></li>)
        else (<li><a onclick="{$onclick}" href="{$l}{$current -1}">«</a></li>)
        else (<li class="disabled"><a href="#">«</a></li>)
    }

     { 
        for $i in ($start to $end)
        return  if($current = $i) then <li class="active"><a onclick="{$onclick}" href="{$l}{$i}">{$i}</a></li>
        else <li><a onclick="{$onclick}" href="{$l}{$i}">{$i}</a></li>

     }
     {
        if ($current != $total) then
          if ($end < $total - 2) then
          ( <li class="disabled"><a href="#">…</a></li>,
      <li><a onclick="{$onclick}" href="{$l}{$total}">{$total}</a></li>,
      <li><a onclick="{$onclick}" href="{$l}{$current +1}">»</a></li>)
          else 
        if ($end = $total - 2) then
      ( <li><a onclick="{$onclick}" href="{$l}{$total -1}">{$total -1}</a></li>,
        <li><a onclick="{$onclick}" href="{$l}{$total}">{$total}</a></li>,
        <li><a onclick="{$onclick}" href="{$l}{$current +1}">»</a></li>)
      else
        if ($end = $total - 1) then
        ( <li><a onclick="{$onclick}" href="{$l}{$total}">{$total}</a></li>,
          <li><a onclick="{$onclick}" href="{$l}{$current +1}">»</a></li>)
        else(<li><a onclick="{$onclick}" href="{$l}{$current +1}">»</a></li>)
        else <li class="disabled"><a href="#">»</a></li>
    }
    </ul>
  </div>
};
