(:~
 : Utility functions for web applications.
 :
 : @author BaseX GmbH 2012, Christian Grün
 :)
module namespace _ = 'http://basex.org/modules/web/util';

(:~
 : Creates an RESTXQ redirect header.
 : @param page target page
 : @return redirect header
 :)
declare function _:redirect(
  $page as xs:string)
  as element(restxq:response)
{
  <restxq:response>
    <http:response status="302">
      <http:header name="location" value="{ $page }"/>
    </http:response>
  </restxq:response>
};

(:~
 : ...
 :)
declare function _:tabs(
  $items as map(*))
{
  <div class="tabbable">
    <ul class="nav nav-tabs">
      {
          let $k := for $key at $pos in map:keys($items)
          order by $key return $key
          for $key at $pos in $k
          return <li>{if($pos = 1) then
            attribute {"class"} {"tab-pane active"}
            else attribute {"class"} {"tab-pane"}}
          <a href="#tab{$pos}" data-toggle="tab">{if(contains($key, "__")) then substring-after($key, "__") else $key}</a></li>
      }
    </ul>
    <div class="tab-content">
      {
        let $k := for $key at $pos in map:keys($items)
        order by $key return $key
        for $key at $pos in $k
        order by $key
        return
        <div id="tab{$pos}">
        {if($pos = 1) then
          attribute {"class"} {"tab-pane active"}
          else attribute {"class"} {"tab-pane"}}
        {$items($key)}
      </div>
    }
      
    </div>
  </div>
};

(:~
 : ...
 :)
declare function _:map-to-params(
  $link as xs:string,
  $params as map(*))
  as xs:string?
{
  $link ||"?"|| string-join(
    for $key in map:keys($params)
    return $params($key) ! ($key || "=" || .), "&amp;") 
};

