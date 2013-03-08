(:~
 : Copyright 2013 Dirk Kirsten

 : This program is free software: you can redistribute it and/or modify
 : it under the terms of the GNU General Public License as published by
 : the Free Software Foundation, either version 3 of the License, or
 : (at your option) any later version.

 : This program is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 : GNU General Public License for more details.

 : You should have received a copy of the GNU General Public License
 : along with this program.  If not, see <http://www.gnu.org/licenses/>.
 :)

module namespace _ = 'http://xquery-fiddle.org/engine';

(:~
 : Main entry page. Creates a new database and redirects the user to this
 : instance.
 :)
declare
  %updating
  %restxq:path("/")
  function _:index()
{
  let $id := random:uuid()
  return (
    db:create($id,
      <config>
        <user />
        <result />
        <version>1</version>
        <statistics>
          <accessed>0</accessed>
          <lastAccess />
        </statistics>
      </config>,
      "config.xml"),
    db:output(_:redirect("/restxq/" || $id))
  )
};

(:~
 : Main page. Output the html
 : @param id fiddle id
 :)
declare
  %restxq:path("/{$id}")
  %output:method("xhtml")
  %output:omit-xml-declaration("no")
  %output:doctype-public("-//W3C//DTD XHTML 1.0 Transitional//EN")
  %output:doctype-system("http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd")
  function _:fiddle($id as xs:string)
{
  doc("html/main.html")
};

(:~
 : Get the current version number for the given fiddle
 : @param id fiddle id
 :)
declare
  %restxq:path("/version/{$id}")
  %output:method("json")
  function _:version($id as xs:string)
{
  let $version := doc($id || "/config.xml")//version
  return <json objects="json" numbers="version">{$version}</json>
};

(:~
 : Requests a new version number for the given fiddle.
 : Updates the config with this new version number, which is now
 : the most recent.
 : @param id fiddle id
 :)
declare
  %updating
  %restxq:path("/version/new/{$id}")
  %output:method("json")
  function _:new-version($id as xs:string)
{
  let $version := doc($id || "/config.xml")//version + 1
  return (
    replace value of node doc($id || "/config.xml")//version with $version,
    db:output(<json objects="json" numbers="version"><version>{$version}</version></json>)
  )
};

(:~
 : Get the relevant data as JSON objects to be included
 : in AngularJS.
 : @param id fiddle id
 : @param version version number
 :)
declare
  %restxq:path("/data/{$id}/{$version}")
  %output:method("json")
  function _:data($id as xs:string, $version as xs:string)
{
  <json objects="json config doc statistics" numbers="accessed version" booleans="selected" arrays="docs">
    <docs>
    {
      for $title at $pos in db:list($id, $version)[not(. = "config.xml" or . = $version || "/config.xml")]
      let $content := doc($id || "/" || $title)
      let $selected := if ($pos = 1) then "true" else "false"
      where starts-with($title, $version)
      return
        <doc>
          <title>{substring($title, string-length($version) + 2)}</title>
          <content>{serialize($content)}</content>
          <selected>{$selected}</selected>
        </doc>
    }
    </docs>
    <config>
      {
        let $global-config := doc($id || "/config.xml")
        let $local-config := try { doc($id || "/" || $version || "/config.xml") } catch * {()}
        return (
          $global-config//version,
          $local-config//xquery,
          $local-config//result,
          $local-config//processor
        )
      }
    </config>
  </json>
};

(:~
 : Saves the given XQuery for a specific version of a fiddle.
 : @param id fiddle id
 : @param version version number
 : @param query query to be saved
 :)
declare
  %updating
  %restxq:path("/save-xquery/{$id}/{$version}")
  %restxq:POST("{$query}")
  function _:save-xquery($id as xs:string, $version as xs:string, $query as xs:string)
{
  db:add($id, <config><xquery>{$query}</xquery></config>, $version || "/config.xml")
};

(:~
 : Save the result of a XQuery and the used processor in
 : the config files of the specific version of the fiddle.
 : @param id fiddle id
 : @param version version number
 : @param processor the used processor id
 : @param result the result of an executed XQuery
 :)
declare
  %updating
  %restxq:path("/save-result/{$id}/{$version}/{$processor}")
  %restxq:POST("{$result}")
  function _:save-result($id as xs:string, $version as xs:string, $processor as xs:string, $result as xs:string)
{
  (
    insert node <result>{$result}</result> into doc($id || "/" || $version || "/config.xml")//config,
    insert node <processor>{$processor}</processor> into doc($id || "/" || $version || "/config.xml")//config
  )
};

(:~
 : Executes a XQuery.
 : @param id fiddle id
 : @param version version number
 : @param query executed query
 :)
declare
  %updating
  %restxq:path("/execute-xquery/{$id}/{$version}")
  %restxq:POST("{$query}")
  %output:method("json")
  function _:execute-xquery($id as xs:string, $version as xs:string, $query as xs:string)
{
  db:output(
    try {
      <json objects="json">
        <result>
          {serialize(xquery:eval($query, map { '' := db:open($id, $version) }))}
        </result>
      </json>
    } catch * {
      <json objects="json error">
        <error>
          <code>{$err:code}</code>
          <description>{$err:description}</description>
          <line>{$err:line-number}</line>
          <column>{$err:column-number}</column>
        </error>
      </json>
    }
  )
};

(:~
 : Creates an RESTXQ redirect header.
 : @param page target page
 : @return redirect header
 :)
 declare function _:redirect(
   $page as xs:string
  ) as element(restxq:response)
{
  <restxq:response>
    <http:response status="302">
      <http:header name="location" value="{ $page }"/>
    </http:response>
  </restxq:response>
};
