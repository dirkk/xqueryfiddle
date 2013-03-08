module namespace _ = "http://napers.lindau-nobel.org/model";

(:~
 : Load the form at the provided file path
 :
 : @param path path to the form file
 :)
declare %private function _:form(
  $path as xs:string
) {
  if(starts-with(file:resolve-path("."), "/opt/tomcat/temp/")) then
    doc("/opt/tomcat/webapps/ROOT/xforms/" || $path)
  else
    doc("xforms/" || $path)
};
