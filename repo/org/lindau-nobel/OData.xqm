(:~
 : Create an OData url from a map.
 :
 : (C) 2012, Nobelstiftung
 : by Dirk Kirsten (BaseX GmbH)
 :)
module namespace _ = 'http://lindau-nobel.org/OData';

import module namespace C = 'http://lindau-nobel.org/constants';

declare namespace d = "http://schemas.microsoft.com/ado/2007/08/dataservices";
declare namespace m = "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata";

declare function _:get-url($map as map(*)) as xs:string {
  _:get-url($C:ODATA-URL, $map)
};

(:~
 : Create URL from a specific map. The map must have an element named
 : <i>Table</i>, containing the table to be requested. It can have an
 : <i>ID</i> element, if a specific ID is requested.
 :
 : The following OData query options are only valid at the top level:
 :  - $filter
 :  - $skip
 :  - $top
 :  - $orderby
 : Tables can be recursivly interleaved. Every element not starting with $
 : will be represented as another table and later concatenated for expanding
 : them using OData. In the lower levels of table structures, only the
 : following query option is valid:
 :  - $select
 :
 : @param base-url URL of the OData service interface
 : @param map Represents the OData URL
 :)
declare function _:get-url($base-url as xs:string, $map as map(*)) as xs:string {
  if (map:contains($map, "Table"))
  then
    let $base :=
      if (map:contains($map, "ID"))
      then $base-url || $map("Table") || "(guid'" ||  $map("ID") || "')"
      else $base-url || $map("Table")
    let $step := _:step("", map:remove(map:remove($map, "Table"), "ID"))
    return
      if ($step != '')
      then $base || "?" || $step
      else $base
  else
    error(QName('http://www.w3.org/2005/xqt-errors', 'err:WEBR0001'))
};

declare %private function _:step($loc as xs:string, $map as map(*)) as xs:string {
  let $rec :=
    for $table in map:keys($map)
    where not(starts-with($table, '$'))
    return _:step-into($table, $map($table))
  let $select :=
    if (empty($rec))
    then $map("$select")
    else (for $r in $rec return $r("$select"), $map("$select"))
  let $expand :=
    if (empty($rec))
    then ()
    else for $r in $rec return $r("$expand")

  let $commands := (
    for $entry in map:keys($map)
    where starts-with($entry, '$') and $entry != "$select" and $entry != "$expand"
    return $entry || "=" || _:encode($map($entry)),

    if (empty($rec))
    then
      if (map:contains($map, "$select"))
      then "$select=" || _:encode(string-join($map("$select"), ','))
      else ()
    else (
      "$select=" || _:encode(string-join($select, ',')),
      "$expand=" || _:encode(string-join($expand, ','))
    )
  )
  return string-join($commands, '&amp;')
};

declare %private function _:step-into($loc as xs:string, $map as map(*)) as map(*) {
  let $tables := 
    for $key in map:keys($map)
    where not(starts-with($key, '$'))
    return $key
  let $rec :=
    for $table in $tables
    return _:step-into($loc || "/" || $table, $map($table))
  return
    map {
      "$expand" := (
        $loc,
        for $table in $rec
        return $table("$expand")
      ),
      "$select" := (
        for $query-object in $map("$select")
        return $loc || "/" || $query-object,
        for $table in $rec
        return $table("$select")
      )
    }
};

(:~
 : Encode the input to be submitted as URL for OData. Currently only replaces
 : whitespaces with %20
 :
 : @param plain plain input
 : @return URL encoded string
 :)
declare %private function _:encode($plain) as xs:string {
  if ($plain instance of xs:string)
  then replace($plain, " ", "%20")
  else
    if ($plain instance of xs:integer)
    then xs:string($plain)
    else ""
};

declare function _:transform($input as node())
{
  for $x in $input/*
  let $c := element { QName('http://schemas.microsoft.com/ado/2007/08/dataservices', 'd:' || local-name($x)) } {$x/text()}
  return
    if (empty($c/text())) then
      copy $copy := $c
      modify insert node (attribute {"m:null"} {"true"}) into $copy
      return $copy
    else $c
};

declare function _:boilerplate(
  $table as xs:string,
  $properties as item()*
)
{
    <entry xml:base="{$C:ODATA-URL}" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns="http://www.w3.org/2005/Atom">
      <title type="text"></title>
      <author>
        <name />
      </author>
      <category term="LindauNobelCRMModel.{$table}" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme" />
      <content type="application/xml">
        <m:properties>
         {$properties}
        </m:properties>
      </content>
    </entry>
};
