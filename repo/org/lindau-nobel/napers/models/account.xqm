module namespace _ = "http://napers.lindau-nobel.org/models/account";

import module namespace C = "http://lindau-nobel.org/constants";
import module namespace session = "http://basex.org/modules/web/session";
import module namespace tmpl = "http://napers.lindau-nobel.org/tmpl";
import module namespace ex= "http://lindau-nobel.org/exchange";
import module namespace odata = "http://lindau-nobel.org/OData";

declare namespace xf = "http://www.w3.org/2002/xforms";
declare namespace ev = "http://www.w3.org/2001/xml-events";

declare namespace d = "http://schemas.microsoft.com/ado/2007/08/dataservices";
declare namespace m = "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata";

(:~
 : Model for changing the account email address
 :
 : @param email current email address
 :)
declare 
  %restxq:GET
  %restxq:path("/json/account")
  %output:method("json")
  function _:email()
{
  <json objects="json">
  {
    for $e in ex:get(odata:get-url( map {
      "Table" := "WebAccounts",
      "ID" := session:id(),
      "$select" := ("P_Username", "C_Email")
    }))/*:entry/*:content/*:properties/*
    return element {replace(local-name($e), "_", "__")} {$e/text()}
  }
  </json>
};
