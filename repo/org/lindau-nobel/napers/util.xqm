module namespace _ = "http://napers.lindau-nobel.org/util";

import module namespace C = 'http://lindau-nobel.org/constants';
import module namespace ex = "http://lindau-nobel.org/exchange";
import module namespace odata = "http://lindau-nobel.org/OData";

declare %private function _:move-file(
  $change as xs:string,
  $old-file-node as element(),
  $old-file-name-node as element(),
  $new-file as xs:string
) {
  if ($change = 'true') then
    try { 
      let $old-file := $old-file-node/text()
      let $old-file-name := $old-file-name-node/text()
      let $id := random:uuid()
      let $move := file:move(substring(Q{java:java.net.URLDecoder}decode(xs:string($old-file), xs:string("UTF-8")), 2), $new-file)
      let $body-file :=
        <entry xml:base="{$C:ODATA-URL}" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata" xmlns="http://www.w3.org/2005/Atom">
          <title type="text"></title>
          <author>
            <name />
          </author>
          <category term="LindauNobelCRMModel.DocumentsUser" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme" />
          <content type="application/xml">
            <m:properties>
              <d:ID>{$id}</d:ID>
              <d:FileName>{$old-file-name}</d:FileName>
              <d:ServerPath>{$new-file}</d:ServerPath>
            </m:properties>
          </content>
        </entry>
      let $post := ex:post(odata:get-url( map { "Table" := "DocumentsUser" }), $body-file)
      return
        $id
    }
    catch * {
      ()
    }
  else ()
};

declare %private function _:get-infotext($number as xs:string) {
  let $req := "<span>" || ex:get(odata:get-url( map {
    "Table" := "NAPERS",
    "$filter" := "FieldName%20eq%20'" || $number || "'"
  }))/*:feed/*:entry/*:content/*:properties/*:Text/text() || "</span>"
  return
    try {
      parse-xml($req)
    } catch * {
      $req
    }
};

declare %private function _:hash($user as xs:string, $pass as xs:string){
  ("AxCMS" || "\" || lower-case($user) || ":" || "AxCMS" || ":" || $pass) 
  ! hash:md5(.) ! xs:hexBinary(.) ! xs:string(.) ! lower-case(.)
};
