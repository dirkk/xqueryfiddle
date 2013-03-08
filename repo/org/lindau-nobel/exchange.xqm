(:~
 : Communication with the ODate interface of the Exchange Server. 
 :
 : (C) 2012, Nobelstiftung
 : by Dirk Kirsten (BaseX GmbH)
 :)
module namespace _ = 'http://lindau-nobel.org/exchange';

(:~
 : Get Data form the specified OData url.
 :
 : @param url url to get data from
 :)
declare function _:get($url as xs:string) as item() {
  let $resp := http:send-request(
    <http:request method="GET" override-media-type="application/gzip" send-authorization="false" username="WebServiceUser" password="wcf#2012-no!" auth-method="Basic" >
      <http:header name="Accept" value="application/atom+xml"/>
      <http:header name="Accept-Encoding" value="gzip, deflate"/>
      <http:header name="Accept-Charset" value="utf-8" />
    </http:request>,
    $url)
  return
    if ($resp[1]/@*:status < 400) then
      try {
        parse-xml(archive:extract-text($resp[2]))
      } catch * {
        parse-xml(convert:binary-to-string($resp[2]))
      }
    else
      let $test := trace($resp, "Failed response using GET: ")
      let $test2 := trace($url, "Calling URL: ")
      return error(QName('http://www.w3.org/2005/xqt-errors', 'err:WEBR0000'))
};

(:~
 : Delete the specified entry. Url has to be a single entry referenced by the
 : guid.
 :
 : @param url entry to be deleted
 :)
declare function _:delete($url as xs:string) as item() {
  let $resp := http:send-request(
    <http:request method="DELETE" send-authorization="false" username="WebServiceUser" password="wcf#2012-no!" auth-method="Basic" >
      <http:header name="Accept" value="application/*"/>
      <http:header name="Accept-Charset" value="utf-8" />
    </http:request>,
    $url)
  return
    if ($resp[1]/@*:status < 400) then
      $resp[2]
    else
      let $test := trace($resp, "Failed response using DELETE: ")
      let $test2 := trace($url, "Calling URL: ")
      return error(QName('http://www.w3.org/2005/xqt-errors', 'err:WEBR0000'))
};

(:~
 : Change the entry at the given url and override all data with the given
 : data. Note, that all entryies which are not included in the body, but are
 : part of the database entry, are set to their default value
 :
 : @param url url
 : @param body new values
 :)
declare function _:put($url as xs:string, $body as item()*) as xs:boolean {
  let $resp := http:send-request(
    <http:request method="put" send-authorization="false" username="WebServiceUser" password="wcf#2012-no!" auth-method="Basic" >
      <http:header name="Accept" value="application/*"/>
      <http:header name="Accept-Charset" value="utf-8"/>
        <http:body media-type="application/atom+xml; charset=utf-8" method="xml" encoding="utf-8">
        {$body}
        </http:body>
    </http:request>,
    $url)
  return
    if ($resp[1]/@*:status < 400) then
      true()
    else
      let $test := trace($resp, "Failed response using PUT: ")
      let $test2 := trace($url, "Calling URL: ")
      return error(QName('http://www.w3.org/2005/xqt-errors', 'err:WEBR0001'))
};

(:~ 
 : At first, get the entry using GET. Then include all the values of this GET
 : request into the new body, which are missing there (i.e. supplement the new
 : values with the unchanged old ones).
 : Then PUT this to the given URL.
 :
 : This could be done a lot easier and more efficiently using the custom HTTP
 : method MERGE, which is supported by OData. However, this is currently not
 : possible with the HTTP module due to the limitations of the java
 : implementation.
 :
 : @param url OData url to merge to
 : @param body values to override
 :)
declare function _:merge($url as xs:string, $body as item()*) as xs:boolean {
  let $req := _:get($url)
  let $newBody :=
    copy $c := $body
    modify (
      for $r in $req//*:properties/*
      let $name := local-name($r)
      let $target := $c//*[local-name(.) = $name]
      return
        if (exists($target)) then
          ()
        else
          insert node $r into $c//*:properties
    )
    return $c
  let $ok := _:put($url, $newBody)
  return true()
};

(:~
 : Insert a new entry into the database. URL has to be on one specific table
 : and include the new ID.
 :
 : @param url url
 : @param body new entry
 :)
declare function _:post($url as xs:string, $body as item()*) as item()* {
  let $resp := http:send-request(
    <http:request method="post" send-authorization="false" username="WebServiceUser" password="wcf#2012-no!" auth-method="Basic">
      <http:header name="Accept" value="application/*"/>
      <http:header name="Accept-Charset" value="utf-8"/>
        <http:body media-type="application/atom+xml; charset=utf-8">
        {$body}
       </http:body>
    </http:request>,
    ($url))
  return
    if ($resp/@*:status < 400) then
      $resp
    else
      let $test := trace($resp, "Failed response using POST: ")
      let $test2 := trace($url, "Calling URL: ")
      return error(QName('http://www.w3.org/2005/xqt-errors', 'err:WEBR0001'))
};
