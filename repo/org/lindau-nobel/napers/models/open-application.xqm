module namespace _ = "http://napers.lindau-nobel.org/models/open-application";

import module namespace C = "http://lindau-nobel.org/constants";
import module namespace session = "http://basex.org/modules/web/session";
import module namespace tmpl = "http://napers.lindau-nobel.org/tmpl";
import module namespace ex= "http://lindau-nobel.org/exchange";
import module namespace odata = "http://lindau-nobel.org/OData";

declare namespace xf = "http://www.w3.org/2002/xforms";
declare namespace ev = "http://www.w3.org/2001/xml-events";

declare namespace d = "http://schemas.microsoft.com/ado/2007/08/dataservices";
declare namespace m = "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata";

declare variable $_:co := "http://schemas.microsoft.com/ado/2007/08/dataservices/related/ContactOptions";
declare variable $_:qualifications := "http://schemas.microsoft.com/ado/2007/08/dataservices/related/Qualifications";

declare %private function _:open-application-pre(
  $meeting-id as xs:string,
  $country as xs:string)
{
  let $accept-date := current-date() - xs:yearMonthDuration('P35Y0M')
  return (
    <xf:instance xmlns="" id="data">
     <data> <m:properties xmlns="http://www.w3.org/2005/Atom" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices">
        <d:ID_Meeting>{$meeting-id}</d:ID_Meeting>
        <d:A_Country>{$country}</d:A_Country>
        <d:P_DateOfBirth xsi:nil="true" />
        <d:P_NotAccepted xsi:nil="true" />
        <d:P_Studying xsi:nil="true" />
        <d:P_PostDoc xsi:nil="true" />
        <d:P_TravelCost xsi:nil="true" />
        <d:P_CreateApplication xsi:nil="true" />
      </m:properties></data>
    </xf:instance>,
    <xf:instance id="extra" xmlns="">
      <data>
        <Day/>
        <Month/>
        <Year/>
      </data>
    </xf:instance>,
    <xf:instance id="URL-container" xmlns="">
      <URL/>
    </xf:instance>,

    <xf:bind id="P_DateOfBirth_Day" nodeset="instance('extra')/Day" type="xs:integer" />,
    <xf:bind id="P_DateOfBirth_Month" nodeset="instance('extra')/Month" type="xs:integer" />,
    <xf:bind id="P_DateOfBirth_Year" nodeset="instance('extra')/Year" type="xs:integer" />,
    <xf:bind id="P_NotAccepted" nodeset="m:properties/d:P_NotAccepted" type="xs:boolean" relevant="(instance('data')/m:properties/d:P_DateOfBirth != '' and xs:date(instance('data')/m:properties/d:P_DateOfBirth) lt xs:date('{$accept-date}')) or (instance('data')/m:properties/d:P_PostDoc = 'false')" />,
    <xf:bind id="P_Studying" nodeset="m:properties/d:P_Studying" type="xs:boolean" relevant="instance('data')/m:properties/d:P_DateOfBirth != '' and xs:date(instance('data')/m:properties/d:P_DateOfBirth) gt xs:date('{$accept-date}')" />,
    <xf:bind id="P_PostDoc" nodeset="m:properties/d:P_PostDoc" type="xs:boolean" relevant="instance('data')/m:properties/d:P_DateOfBirth != '' and xs:date(instance('data')/m:properties/d:P_DateOfBirth) gt xs:date('{$accept-date}') and instance('data')/m:properties/d:P_Studying = 'false'" />,
    <xf:bind id="P_TravelCost" nodeset="m:properties/d:P_TravelCost" type="xs:boolean" relevant="instance('data')/m:properties/d:P_DateOfBirth != '' and xs:date(instance('data')/m:properties/d:P_DateOfBirth) gt xs:date('{$accept-date}') and (instance('data')/m:properties/d:P_Studying = 'true' or instance('data')/m:properties/d:P_PostDoc = 'true')" />,
    <xf:bind id="P_CreateApplication" nodeset="m:properties/d:P_CreateApplication" type="xs:boolean" relevant="instance('data')/m:properties/d:P_DateOfBirth != '' and xs:date(instance('data')/m:properties/d:P_DateOfBirth) gt xs:date('{$accept-date}') and (instance('data')/m:properties/d:P_Studying = 'true' or instance('data')/m:properties/d:P_PostDoc = 'true') and (instance('data')/m:properties/d:P_TravelCost != '')" />,

    <xf:submission id="oa" resource="/restxq/open-application/main" method="post" replace="none">
    </xf:submission>
  )
};

declare %private function _:open-application-create(
  $id as xs:string,
  $meeting-id as xs:string,
  $country as xs:string,
  $travel-grant as xs:boolean,
  $birthday as xs:date
)
{
    <xf:instance xmlns="" id="data">
     <data> <m:properties xmlns="http://www.w3.org/2005/Atom" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices">
        <d:ID>{$id}</d:ID>
        <d:ID_Meeting>{$meeting-id}</d:ID_Meeting>
        <d:A_Country>{$country}</d:A_Country>
        <d:P_TravelGrant>{$travel-grant}</d:P_TravelGrant>
        <d:P_DateOfBirth>{$birthday}</d:P_DateOfBirth>
        <d:C_Email xsi:nil="true" />
        <d:P_Password xsi:nil="true" />
        <d:P_Password2 xsi:nil="true" />
      </m:properties></data>
    </xf:instance>,
    <xf:instance id="URL-container" xmlns="">
      <URL/>
    </xf:instance>,
    <xf:instance id="error" xmlns="">
      <data>
      </data>
    </xf:instance>,

    <xf:bind id="ID" nodeset="m:properties/d:ID" type="xs:string" />,
    <xf:bind id="C_Email" nodeset="m:properties/d:C_Email" required="true()" type="xs:string" constraint="matches(., '[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]+')" />,
    <xf:bind id="P_Password" nodeset="m:properties/d:P_Password" required="true()" type="xs:string" constraint="string-length(.) >= 6" />,
    <xf:bind id="P_Password2" nodeset="m:properties/d:P_Password2" required="true()" type="xs:string" constraint=". = '' or . = instance('data')/m:properties/d:P_Password" />,

    <xf:submission id="create-oa" resource="/restxq/open-application/create-account" method="post" ref="instance('data')" replace="instance" instance="error">
      <xf:toggle case="case-busy" ev:event="xforms-submit" />
      <xf:toggle case="case-submit-error" ev:event="xforms-submit-error" />
      <xf:toggle case="case-submit-error" ev:event="xforms-submit-done" if="exists(instance('error')/*:message[@*:class = 'error'])" />
      <xf:toggle case="case-submit-done" ev:event="xforms-submit-done" if="exists(instance('error')/*:message[@*:class = 'ok'])" />
    </xf:submission>
};

declare %private function _:open-application-sr(
  $id as xs:string
)
{
  let $data := ex:get(odata:get-url( map {
    "Table" := "OpenApplications",
    "ID" := $id
  }))/*:entry/*:content/*:properties
  return (
    <xf:instance xmlns="" id="data">
      <data>
        <content>
        {
          copy $c := $data
          modify replace value of node $c/d:P_DateOfBirth with substring($c/d:P_DateOfBirth/text(), 1, 10)
          return $c
        }
        </content>
        <uploads>
          {
            if ($data/*:ID_ScanPhotoID/text()) then
	      let $doc-raw := ex:get(odata:get-url( map {
          "Table" := "DocumentsUser",
          "ID" := $data/*:ID_ScanPhotoID/text()
        }))/*:entry/*:content/*:properties
        let $doc :=
          if (contains($doc-raw/*:ServerPath/text(), "open-application/")) then
            $doc-raw
          else
            copy $c := $doc-raw
            modify replace value of node $c/*:ServerPath with replace($c/*:ServerPath/text(), "open-application", "open-application/")
            return $c
	      return (
		<d:Q_ScanPhotoID>{$C:BASE-URL || "/restxq/file/" || $doc/*:ID/text()}</d:Q_ScanPhotoID>,
		<d:Q_ScanPhotoIDFileName>{$doc/*:FileName/text()}</d:Q_ScanPhotoIDFileName>
	      )
            else
              <d:Q_ScanPhotoID />
          }
	  <d:Q_ScanPhotoIDNot />
          {
            if ($data/*:ID_ScanCertificate1/text()) then
	      let $doc-raw := ex:get(odata:get-url( map {
          "Table" := "DocumentsUser",
          "ID" := $data/*:ID_ScanCertificate1/text()
        }))/*:entry/*:content/*:properties
        let $doc :=
          if (contains($doc-raw/*:ServerPath/text(), "open-application/")) then
            $doc-raw
          else
            copy $c := $doc-raw
            modify replace value of node $c/*:ServerPath with replace($c/*:ServerPath/text(), "open-application", "open-application/")
            return $c
	      return (
		<d:Q_ScanCertificate1>{$C:BASE-URL || "/restxq/file/" || $doc/*:ID/text()}</d:Q_ScanCertificate1>,
		<d:Q_ScanCertificate1FileName>{$doc/*:FileName/text()}</d:Q_ScanCertificate1FileName>
	      )
            else
              <d:Q_ScanCertificate1 />
          }
	  <d:Q_ScanCertificate1Not />
          {
            if ($data/*:ID_ScanCertificate2/text()) then
	      let $doc-raw := ex:get(odata:get-url( map {
          "Table" := "DocumentsUser",
          "ID" := $data/*:ID_ScanCertificate2/text()
        }))/*:entry/*:content/*:properties
        let $doc :=
          if (contains($doc-raw/*:ServerPath/text(), "open-application/")) then
            $doc-raw
          else
            copy $c := $doc-raw
            modify replace value of node $c/*:ServerPath with replace($c/*:ServerPath/text(), "open-application", "open-application/")
            return $c
	      return (
		<d:Q_ScanCertificate2>{$C:BASE-URL || "/restxq/file/" || $doc/*:ID/text()}</d:Q_ScanCertificate2>,
		<d:Q_ScanCertificate2FileName>{$doc/*:FileName/text()}</d:Q_ScanCertificate2FileName>
	      )
            else
              <d:Q_ScanCertificate2 />
          }
	  <d:Q_ScanCertificate2Not />
          {
            if ($data/*:ID_ScanCertificateDoctoralDegree/text()) then
	      let $doc-raw := ex:get(odata:get-url( map {
          "Table" := "DocumentsUser",
          "ID" := $data/*:ID_ScanCertificateDoctoralDegree/text()
        }))/*:entry/*:content/*:properties
        let $doc :=
          if (contains($doc-raw/*:ServerPath/text(), "open-application/")) then
            $doc-raw
          else
            copy $c := $doc-raw
            modify replace value of node $c/*:ServerPath with replace($c/*:ServerPath/text(), "open-application", "open-application/")
            return $c
	      return (
		<d:Q_ScanCertificateDoctoralDegree>{$C:BASE-URL || "/restxq/file/" || $doc/*:ID/text()}</d:Q_ScanCertificateDoctoralDegree>,
		<d:Q_ScanCertificateDoctoralDegreeFileName>{$doc/*:FileName/text()}</d:Q_ScanCertificateDoctoralDegreeFileName>
	      )
            else
              <d:Q_ScanCertificateDoctoralDegree />
          }
	  <d:Q_ScanCertificateDoctoralDegreeNot />
          {
            if ($data/*:ID_LetterOfRecommendation1/text()) then
	      let $doc-raw := ex:get(odata:get-url( map {
          "Table" := "DocumentsUser",
          "ID" := $data/*:ID_LetterOfRecommendation1/text()
        }))/*:entry/*:content/*:properties
        let $doc :=
          if (contains($doc-raw/*:ServerPath/text(), "open-application/")) then
            $doc-raw
          else
            copy $c := $doc-raw
            modify replace value of node $c/*:ServerPath with replace($c/*:ServerPath/text(), "open-application", "open-application/")
            return $c
	      return (
		<d:Q_LetterOfRecommendation1>{$C:BASE-URL || "/restxq/file" || $doc/*:ID/text()}</d:Q_LetterOfRecommendation1>,
		<d:Q_LetterOfRecommendation1FileName>{$doc/*:FileName/text()}</d:Q_LetterOfRecommendation1FileName>
	      )
            else
              <d:Q_LetterOfRecommendation1 />
          }
	  <d:Q_LetterOfRecommendation1Not />          {
            if ($data/*:ID_LetterOfRecommendation2/text()) then
	      let $doc-raw := ex:get(odata:get-url( map {
          "Table" := "DocumentsUser",
          "ID" := $data/*:ID_LetterOfRecommendation2/text()
        }))/*:entry/*:content/*:properties
        let $doc :=
          if (contains($doc-raw/*:ServerPath/text(), "open-application/")) then
            $doc-raw
          else
            copy $c := $doc-raw
            modify replace value of node $c/*:ServerPath with replace($c/*:ServerPath/text(), "open-application", "open-application/")
            return $c
	      return (
		<d:Q_LetterOfRecommendation2>{$C:BASE-URL || "/restxq/file/" || $doc/*:ID/text()}</d:Q_LetterOfRecommendation2>,
		<d:Q_LetterOfRecommendation2FileName>{$doc/*:FileName/text()}</d:Q_LetterOfRecommendation2FileName>
	      )
            else
              <d:Q_LetterOfRecommendation2 />
          }
	  <d:Q_LetterOfRecommendation2Not />
        </uploads>
      </data>
    </xf:instance>,
    <xf:instance xmlns="" id="countries">
      <countries>{
        let $countries := ex:get(odata:get-url( map {
          "Table" := "NAPERSCountries",
          "$orderby" := "Country"
        }))/*:feed/*:entry
        for $m in $countries
        let $v := $m/*:content/*:properties
        return
          <item>
            <label>{$v/*:Country/text()}</label>
            <value>{$v/*:CountryCode/text()}</value>
          </item>
      }</countries>
    </xf:instance>,
    <xf:instance xmlns="" id="prop">
      <data>
        <readonly-self>true</readonly-self>
	{
	  if (empty($data/*:E_EvaluationComplete/text()) or $data/*:E_EvaluationComplete/text() != 'true') then
	    <readonly-sr>false</readonly-sr>
	  else
	    <readonly-sr>true</readonly-sr>
	}
	<trigger />
	<sr-trigger />
        <id xsi:nil="true" />
      </data>
    </xf:instance>,
    <xf:instance id="extra" xmlns="">
      <data>
      {
        (: Calculate the birthday :)
        if ($data/*:P_DateOfBirth/text() != "") then (
          <Day>{let $day := day-from-dateTime($data/*:P_DateOfBirth) return if ($day < 10) then "0" || $day else $day}</Day>,
          <Month>{let $month := month-from-dateTime($data/*:P_DateOfBirth) return if ($month < 10) then "0" || $month else $month}</Month>,
          <Year>{year-from-dateTime($data/*:P_DateOfBirth)}</Year>
        ) else (
          <Day xsi:nil="true" />,
          <Month xsi:nil="true" />,
          <Year xsi:nil="true" />
        )
      }
      </data>
    </xf:instance>,

    <xf:bind id="ID" nodeset="content/m:properties/d:ID" type="xs:string" />,
    <xf:bind id="P_TitleAcademicPre" nodeset="content/m:properties/d:P_TitleAcademicPre" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="P_TitleAcademicPost" nodeset="content/m:properties/d:P_TitleAcademicPost" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="P_NameFirst" nodeset="content/m:properties/d:P_NameFirst" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="P_NameMiddle" nodeset="content/m:properties/d:P_NameMiddle" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="P_NameLast" nodeset="content/m:properties/d:P_NameLast" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="P_NameLastPre" nodeset="content/m:properties/d:P_NameLastPre" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="P_DateOfBirth_Day" nodeset="instance('extra')/Day" type="xs:integer" readonly="instance('prop')/readonly-self = 'true'"  />,
    <xf:bind id="P_DateOfBirth_Month" nodeset="instance('extra')/Month" type="xs:integer" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="P_DateOfBirth_Year" nodeset="instance('extra')/Year" type="xs:integer" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="P_Gender" nodeset="content/m:properties/d:P_Gender" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="P_CountryOfBirth" nodeset="content/m:properties/d:P_CountryOfBirth" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="P_Nationality" nodeset="content/m:properties/d:P_Nationality" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="C_Email" nodeset="content/m:properties/d:C_Email" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="A_Institution" nodeset="content/m:properties/d:A_Institution" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="A_Department" nodeset="content/m:properties/d:A_Department" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="A_City" nodeset="content/m:properties/d:A_City" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="A_Country" nodeset="content/m:properties/d:A_Country" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_FieldOfStudy1" nodeset="content/m:properties/d:Q_FieldOfStudy1" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_FieldOfStudy2" nodeset="content/m:properties/d:Q_FieldOfStudy2" type="xs:string" relevant="instance('data')/content/m:properties/d:Q_FieldOfStudy1 != ''"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_FieldOfStudy3" nodeset="content/m:properties/d:Q_FieldOfStudy3" type="xs:string" relevant="instance('data')/content/m:properties/d:Q_FieldOfStudy1 != '' and instance('data')/m:properties/d:Q_FieldOfStudy2 != ''" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_HighestDegreeObtained1" nodeset="content/m:properties/d:Q_HighestDegreeObtained1" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_HighestDegreeObtained2" nodeset="content/m:properties/d:Q_HighestDegreeObtained2" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_DoctoralDegree" nodeset="content/m:properties/d:Q_DoctoralDegree" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_DoctoralThesis" nodeset="content/m:properties/d:Q_DoctoralThesis" type="xs:string" relevant="instance('data')/content/m:properties/d:Q_DoctoralDegree = 'true'" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_MasterThesis" nodeset="content/m:properties/d:Q_MasterThesis" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_StudyFocus" nodeset="content/m:properties/d:Q_StudyFocus" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_FieldsOfInterest" nodeset="content/m:properties/d:Q_FieldsOfInterest" type="xs:string" readonly="instance('prop')/readonly-self = 'true'"  />,
    <xf:bind id="Q_Motivation" nodeset="content/m:properties/d:Q_Motivation" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_Publication1" nodeset="content/m:properties/d:Q_Publication1" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_Publication1DOI" nodeset="content/m:properties/d:Q_Publication1DOI" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_Publication2" nodeset="content/m:properties/d:Q_Publication2" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_Publication2DOI" nodeset="content/m:properties/d:Q_Publication2DOI" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_Publication3" nodeset="content/m:properties/d:Q_Publication3" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_Publication3DOI" nodeset="content/m:properties/d:Q_Publication3DOI" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,

    (: files :)
    <xf:bind id="Q_ScanPhotoID" nodeset="uploads/d:Q_ScanPhotoID" type="xs:string" relevant="instance('data')/uploads/d:Q_ScanPhotoID/text() != ''" />,
    <xf:bind id="Q_ScanPhotoIDNot" nodeset="uploads/d:Q_ScanPhotoIDNot" type="xs:string" relevant="not(instance('data')/uploads/d:Q_ScanPhotoID/text() != '')" />,
    <xf:bind id="Q_ScanCertificate1" nodeset="uploads/d:Q_ScanCertificate1" type="xs:string" relevant="instance('data')/uploads/d:Q_ScanCertificate1/text() != ''" />,
    <xf:bind id="Q_ScanCertificate1Not" nodeset="uploads/d:Q_ScanCertificate1Not" type="xs:string" relevant="not(instance('data')/uploads/d:Q_ScanCertificate1/text() != '')" />,
    <xf:bind id="Q_ScanCertificate2" nodeset="uploads/d:Q_ScanCertificate2" type="xs:string" relevant="instance('data')/uploads/d:Q_ScanCertificate2/text() != ''" />,
    <xf:bind id="Q_ScanCertificate2Not" nodeset="uploads/d:Q_ScanCertificate2Not" type="xs:string" relevant="not(instance('data')/uploads/d:Q_ScanCertificate2/text() != '')" />,
    <xf:bind id="Q_ScanCertificateDoctoralDegree" nodeset="uploads/d:Q_ScanCertificateDoctoralDegree" type="xs:string" relevant="instance('data')/uploads/d:Q_ScanCertificateDoctoralDegree/text() != ''" />,
    <xf:bind id="Q_ScanCertificateDoctoralDegreeNot" nodeset="uploads/d:Q_ScanCertificateDoctoralDegreeNot" type="xs:string" relevant="not(instance('data')/uploads/d:Q_ScanCertificateDoctoralDegree/text() != '')" />,
    <xf:bind id="Q_LetterOfRecommendation1" nodeset="uploads/d:Q_LetterOfRecommendation1" type="xs:string" relevant="instance('data')/uploads/d:Q_LetterOfRecommendation1/text() != ''" />,
    <xf:bind id="Q_LetterOfRecommendation1Not" nodeset="uploads/d:Q_LetterOfRecommendation1Not" type="xs:string" relevant="not(instance('data')/uploads/d:Q_LetterOfRecommendation1/text() != '')" />,
    <xf:bind id="Q_LetterOfRecommendation2" nodeset="uploads/d:Q_LetterOfRecommendation2" type="xs:string" relevant="instance('data')/uploads/d:Q_LetterOfRecommendation2/text() != ''" />,
    <xf:bind id="Q_LetterOfRecommendation2Not" nodeset="uploads/d:Q_LetterOfRecommendation2Not" type="xs:string" relevant="not(instance('data')/uploads/d:Q_LetterOfRecommendation2/text() != '')" />,

    <xf:bind id="Q_LetterOfRecommendation1Author" nodeset="content/m:properties/d:Q_LetterOfRecommendation1Author" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_LetterOfRecommendation1Position" nodeset="content/m:properties/d:Q_LetterOfRecommendation1Position" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_LetterOfRecommendation1Email" nodeset="content/m:properties/d:Q_LetterOfRecommendation1Email" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_LetterOfRecommendation2Author" nodeset="content/m:properties/d:Q_LetterOfRecommendation2Author" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_LetterOfRecommendation2Position" nodeset="content/m:properties/d:Q_LetterOfRecommendation2Position" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_LetterOfRecommendation2Email" nodeset="content/m:properties/d:Q_LetterOfRecommendation2Email" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,

    (: just visible for the Scientific Reviewer :)
    <xf:bind id="E_OverallScore" nodeset="content/m:properties/d:E_OverallScore" type="xs:integer" constraint="string-length(.) &lt; 3" required="true()" readonly="instance('prop')/readonly-sr = 'true'" />,
    <xf:bind id="E_Status" nodeset="content/m:properties/d:E_Status" type="xs:string" constraint="string-length(.) &lt; 100" readonly="true()" />,
    <xf:bind id="E_Comment" nodeset="content/m:properties/d:E_Comment" type="xs:string" constraint="string-length(.) &lt; 500" readonly="instance('prop')/readonly-sr = 'true'" />,

    <xf:bind id="trigger-disabled" nodeset="instance('prop')/trigger" readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="sr-trigger-disabled" nodeset="instance('prop')/sr-trigger" readonly="instance('prop')/readonly-sr = 'true'" />,

    <xf:submission id="save-oa" resource="/restxq/open-application/evaluation/save" method="post" replace="instance" relevant="false" validate="false">
      <xf:action ev:event="xforms-submit-error">
        <script type="text/javascript">
          $('#label-wait').hide();
          $('#label-error').fadeIn(300).delay(3000).fadeOut(300);
        </script>
      </xf:action>
      <xf:action ev:event="xforms-submit-done">
        <script type="text/javascript">
          fluxProcessor.isDirty = false;
          $('#label-wait').hide();
          $('#label-success').fadeIn(300).delay(3000).fadeOut(300);
        </script>
      </xf:action>
    </xf:submission>,
    <xf:submission id="submit-oa" resource="/restxq/open-application/evaluation/submit" method="post" replace="instance" relevant="false" validate="true">
      <xf:action ev:event="xforms-submit-error">
        <xf:message level="ephemeral">Your form could not be saved. Please check all sections for errors.</xf:message>
       <script type="text/javascript">
          $('#label-wait').hide();
          $('#label-error').fadeIn(300).delay(3000).fadeOut(300);
        </script>

      </xf:action>
      <xf:action ev:event="xforms-submit-done">
        <xf:setvalue ref="instance('prop')/readonly-sr">true</xf:setvalue>
        <script type="text/javascript">
          fluxProcessor.isDirty = false;
          $('#label-wait').hide();
          $('#label-submitted').fadeIn(300).delay(3000).fadeOut(300);
        </script>
      </xf:action>
    </xf:submission>
  )
};

declare %private function _:open-application(
  $id as xs:string
)
{
  let $data :=
    copy $c := ex:get(odata:get-url( map {
      "Table" := "OpenApplications",
      "ID" := $id
    }))/*:entry/*:content/*:properties
    modify (
      delete node $c/d:E_OverallScore,
      delete node $c/d:E_Status,
      delete node $c/d:E_Comment,
      delete node $c/d:E_EvaluationComplete
    )
    return $c
  return (
    <xf:instance xmlns="" id="data">
      <data>
        <content>
        {
          copy $c := $data
          modify replace value of node $c/d:P_DateOfBirth with substring($c/d:P_DateOfBirth/text(), 1, 10)
          return $c
        }
        </content>
        <uploads>
          <d:Q_ScanPhotoID />
          <scan-ID-change>false</scan-ID-change>
          {
            if ($data/*:ID_ScanPhotoID/text()) then
              <id-fn>{ex:get(odata:get-url( map {
                "Table" := "DocumentsUser",
                "ID" := $data/*:ID_ScanPhotoID/text()
              }))/*:entry/*:content/*:properties/*:FileName/text()}</id-fn>
            else
              <id-fn xsi:nil="true" />
          }
          <d:Q_ScanCertificate1 />
          <scan1-change>false</scan1-change>
          {
            if ($data/*:ID_ScanCertificate1/text()) then
              <scan1-fn>{ex:get(odata:get-url( map {
                "Table" := "DocumentsUser",
                "ID" := $data/*:ID_ScanCertificate1/text()
              }))/*:entry/*:content/*:properties/*:FileName/text()}</scan1-fn>
            else
              <scan1-fn xsi:nil="true" />
          }
          <d:Q_ScanCertificate2 />
          <scan2-change>false</scan2-change>
          {
            if ($data/*:ID_ScanCertificate2/text()) then
              <scan2-fn>{ex:get(odata:get-url( map {
                "Table" := "DocumentsUser",
                "ID" := $data/*:ID_ScanCertificate2/text()
              }))/*:entry/*:content/*:properties/*:FileName/text()}</scan2-fn>
            else
              <scan2-fn xsi:nil="true" />
          }
          <d:Q_ScanCertificateDoctoralDegree />
          <scan-doctoral-change>false</scan-doctoral-change>
          {
            if ($data/*:ID_ScanCertificateDoctoralDegree/text()) then
              <scan-doctoral-fn>{ex:get(odata:get-url( map {
                "Table" := "DocumentsUser",
                "ID" := $data/*:ID_ScanCertificateDoctoralDegree/text()
              }))/*:entry/*:content/*:properties/*:FileName/text()}</scan-doctoral-fn>
            else
              <scan-doctoral-fn xsi:nil="true" />
          }
          <d:Q_LetterOfRecommendation1 />
          {
            if ($data/*:ID_LetterOfRecommendation1/text()) then
              <recc1-fn>{ex:get(odata:get-url( map {
                "Table" := "DocumentsUser",
                "ID" := $data/*:ID_LetterOfRecommendation1/text()
              }))/*:entry/*:content/*:properties/*:FileName/text()}</recc1-fn>
            else
              <recc1-fn xsi:nil="true" />
          }
          <recc1-change>false</recc1-change>
          <d:Q_LetterOfRecommendation2 />
          <recc2-change>false</recc2-change>
          {
            if ($data/*:ID_LetterOfRecommendation2/text()) then
              <recc2-fn>{ex:get(odata:get-url( map {
                "Table" := "DocumentsUser",
                "ID" := $data/*:ID_LetterOfRecommendation2/text()
              }))/*:entry/*:content/*:properties/*:FileName/text()}</recc2-fn>
            else
              <recc2-fn xsi:nil="true" />
          }
        </uploads>
      </data>
    </xf:instance>,
    <xf:instance xmlns="" id="countries">
      <countries>{
        let $countries := ex:get(odata:get-url( map {
          "Table" := "NAPERSCountries",
          "$orderby" := "Country"
        }))/*:feed/*:entry
        for $m in $countries
        let $v := $m/*:content/*:properties
        return
          <item>
            <label>{$v/*:Country/text()}</label>
            <value>{$v/*:CountryCode/text()}</value>
          </item>
      }</countries>
    </xf:instance>,
    <xf:instance xmlns="" id="prop">
      <data>
        <readonly-self>{
          if ($data/*:Q_ApplicationSubmitted = "true") then
            "true"
          else
            "false"
        }</readonly-self>
        <trigger />
        <recc1 xsi:nil="true" />
        <recc1-mediatype />
        <recc2 xsi:nil="true" />
        <scan1 xsi:nil="true" />
        <scan2 xsi:nil="true" />
        <scan-doctoral xsi:nil="true" />
        <id xsi:nil="true" />
      </data>
    </xf:instance>,
    <xf:instance id="extra" xmlns="">
      <data>
      {
        (: Calculate the birthday :)
        if ($data/*:P_DateOfBirth/text() != "") then (
          <Day>{let $day := day-from-dateTime($data/*:P_DateOfBirth) return if ($day < 10) then "0" || $day else $day}</Day>,
          <Month>{let $month := month-from-dateTime($data/*:P_DateOfBirth) return if ($month < 10) then "0" || $month else $month}</Month>,
          <Year>{year-from-dateTime($data/*:P_DateOfBirth)}</Year>
        ) else (
          <Day xsi:nil="true" />,
          <Month xsi:nil="true" />,
          <Year xsi:nil="true" />
        )
      }
      </data>
    </xf:instance>,

    <xf:bind id="ID" nodeset="content/m:properties/d:ID" type="xs:string" />,
    <xf:bind id="P_TitleAcademicPre" nodeset="content/m:properties/d:P_TitleAcademicPre" type="xs:string" readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 100" />,
    <xf:bind id="P_TitleAcademicPost" nodeset="content/m:properties/d:P_TitleAcademicPost" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 100" />,
    <xf:bind id="P_NameFirst" nodeset="content/m:properties/d:P_NameFirst" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 200" />,
    <xf:bind id="P_NameMiddle" nodeset="content/m:properties/d:P_NameMiddle" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 200" />,
    <xf:bind id="P_NameLast" nodeset="content/m:properties/d:P_NameLast" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 200" />,
    <xf:bind id="P_NameLastPre" nodeset="content/m:properties/d:P_NameLastPre" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 50" />,
    <xf:bind id="P_DateOfBirth_Day" nodeset="instance('extra')/Day" required="true()" type="xs:integer" readonly="instance('prop')/readonly-self = 'true'" constraint=". != ''" />,
    <xf:bind id="P_DateOfBirth_Month" nodeset="instance('extra')/Month" required="true()" type="xs:integer" readonly="instance('prop')/readonly-self = 'true'" constraint=". != ''" />,
    <xf:bind id="P_DateOfBirth_Year" nodeset="instance('extra')/Year" required="true()" type="xs:integer" readonly="instance('prop')/readonly-self = 'true'" constraint=". != ''" />,
    <xf:bind id="P_Gender" nodeset="content/m:properties/d:P_Gender" type="xs:string" required="true()" readonly="instance('prop')/readonly-self = 'true'" constraint=". != ''" />,
    <xf:bind id="P_CountryOfBirth" nodeset="content/m:properties/d:P_CountryOfBirth" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != ''" />,
    <xf:bind id="P_Nationality" nodeset="content/m:properties/d:P_Nationality" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != ''" />,
    <xf:bind id="C_Email" nodeset="content/m:properties/d:C_Email" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 100 and matches(., '[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]+')" />,
    <xf:bind id="A_Institution" nodeset="content/m:properties/d:A_Institution" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 200" />,
    <xf:bind id="A_Department" nodeset="content/m:properties/d:A_Department" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 200" />,
    <xf:bind id="A_City" nodeset="content/m:properties/d:A_City" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 100" />,
    <xf:bind id="A_Country" nodeset="content/m:properties/d:A_Country" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 100" />,
    <xf:bind id="Q_FieldOfStudy1" nodeset="content/m:properties/d:Q_FieldOfStudy1" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 200" />,
    <xf:bind id="Q_FieldOfStudy2" nodeset="content/m:properties/d:Q_FieldOfStudy2" type="xs:string" relevant="instance('data')/content/m:properties/d:Q_FieldOfStudy1 != ''"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 200" />,
    <xf:bind id="Q_FieldOfStudy3" nodeset="content/m:properties/d:Q_FieldOfStudy3" type="xs:string" relevant="instance('data')/content/m:properties/d:Q_FieldOfStudy1 != '' and instance('data')/m:properties/d:Q_FieldOfStudy2 != ''" readonly="instance('prop')/readonly-self = 'true'"  constraint="string-length(.) &lt; 200" />,
    <xf:bind id="Q_HighestDegreeObtained1" nodeset="content/m:properties/d:Q_HighestDegreeObtained1" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 200" />,
    <xf:bind id="Q_HighestDegreeObtained2" nodeset="content/m:properties/d:Q_HighestDegreeObtained2" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 200" />,
    <xf:bind id="Q_DoctoralDegree" nodeset="content/m:properties/d:Q_DoctoralDegree" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" />,
    <xf:bind id="Q_DoctoralThesis" nodeset="content/m:properties/d:Q_DoctoralThesis" type="xs:string" relevant="instance('data')/content/m:properties/d:Q_DoctoralDegree = 'true'" readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 500" />,
    <xf:bind id="Q_MasterThesis" nodeset="content/m:properties/d:Q_MasterThesis" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 500" />,
    <xf:bind id="Q_StudyFocus" nodeset="content/m:properties/d:Q_StudyFocus" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 500" />,
    <xf:bind id="Q_FieldsOfInterest" nodeset="content/m:properties/d:Q_FieldsOfInterest" type="xs:string" required="true()" readonly="instance('prop')/readonly-self = 'true'"  constraint=". != '' and string-length(.) &lt; 500" />,
    <xf:bind id="Q_Motivation" nodeset="content/m:properties/d:Q_Motivation" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 500" />,
    <xf:bind id="Q_Publication1" nodeset="content/m:properties/d:Q_Publication1" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 500" />,
    <xf:bind id="Q_Publication1DOI" nodeset="content/m:properties/d:Q_Publication1DOI" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 50" />,
    <xf:bind id="Q_Publication2" nodeset="content/m:properties/d:Q_Publication2" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 500" />,
    <xf:bind id="Q_Publication2DOI" nodeset="content/m:properties/d:Q_Publication2DOI" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 50" />,
    <xf:bind id="Q_Publication3" nodeset="content/m:properties/d:Q_Publication3" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 500" />,
    <xf:bind id="Q_Publication3DOI" nodeset="content/m:properties/d:Q_Publication3DOI" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 50" />,


    (: #scan photo :)
    <xf:bind
      id="Q_ScanPhotoID"
      nodeset="uploads/d:Q_ScanPhotoID"
      type="xs:anyURI"
      required="true()"
      constraint=". != ''"
      readonly="instance('prop')/readonly-self = 'true'"
      relevant="not(instance('data')/uploads/id-fn/text())" />,
    (: //#scan photo :)


    <xf:bind id="Q_ScanCertificate1" nodeset="uploads/d:Q_ScanCertificate1" type="xs:anyURI" readonly="instance('prop')/readonly-self = 'true'" relevant="not(instance('data')/uploads/scan1-fn/text())" />,
    <xf:bind id="Q_ScanCertificate2" nodeset="uploads/d:Q_ScanCertificate2" type="xs:anyURI" readonly="instance('prop')/readonly-self = 'true'" relevant="not(instance('data')/uploads/scan2-fn/text())" />,
    <xf:bind id="Q_ScanCertificateDoctoralDegree" nodeset="uploads/d:Q_ScanCertificateDoctoralDegree" type="xs:anyURI" relevant="instance('data')/content/m:properties/d:Q_DoctoralDegree = 'true' and not(instance('data')/uploads/scan-doctoral-fn/text())" readonly="instance('prop')/readonly-self = 'true'" />,
    (: #lor # :)
    <xf:bind
      id="Q_LetterOfRecommendation1"
      nodeset="uploads/d:Q_LetterOfRecommendation1"
      type="xs:anyURI"
      required="true()"
      constraint=". != ''"
      readonly="instance('prop')/readonly-self = 'true'"
      relevant="not(instance('data')/uploads/recc1-fn/text())"

      />,
        (: #lor # :)
    <xf:bind id="Q_LetterOfRecommendation1Author" nodeset="content/m:properties/d:Q_LetterOfRecommendation1Author" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 200" />,
    <xf:bind id="Q_LetterOfRecommendation1Position" nodeset="content/m:properties/d:Q_LetterOfRecommendation1Position" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 200" />,
    <xf:bind id="Q_LetterOfRecommendation1Email" nodeset="content/m:properties/d:Q_LetterOfRecommendation1Email" type="xs:string" required="true()"  readonly="instance('prop')/readonly-self = 'true'" constraint=". != '' and string-length(.) &lt; 200 and matches(., '[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]+')" />,
    <xf:bind id="Q_LetterOfRecommendation2" nodeset="uploads/d:Q_LetterOfRecommendation2" type="xs:anyURI"  readonly="instance('prop')/readonly-self = 'true'" relevant="not(instance('data')/uploads/recc2-fn/text())" />,
    <xf:bind id="Q_LetterOfRecommendation2Author" nodeset="content/m:properties/d:Q_LetterOfRecommendation2Author" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 200" />,
    <xf:bind id="Q_LetterOfRecommendation2Position" nodeset="content/m:properties/d:Q_LetterOfRecommendation2Position" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 200" />,
    <xf:bind id="Q_LetterOfRecommendation2Email" nodeset="content/m:properties/d:Q_LetterOfRecommendation2Email" type="xs:string"  readonly="instance('prop')/readonly-self = 'true'" constraint="string-length(.) &lt; 200 and (. = '' or matches(., '[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]+'))" />,

    (: required for file upload :)
    <xf:bind id="Q_LetterOfRecommendation1FileName" nodeset="instance('data')/uploads/recc1-fn" type="xs:string" />,
    <xf:bind id="Q_LetterOfRecommendation1Up" nodeset="instance('prop')/recc1" type="xs:boolean" relevant="instance('data')/uploads/recc1-fn/text() != ''" />,
    <xf:bind id="Q_LetterOfRecommendation2FileName" nodeset="instance('data')/uploads/recc2-fn" type="xs:string" />,
    <xf:bind id="Q_LetterOfRecommendation2Up" nodeset="instance('prop')/recc2" type="xs:boolean" relevant="instance('data')/uploads/recc2-fn/text() != ''" />,
    <xf:bind id="Q_ScanCertificate1FileName" nodeset="instance('data')/uploads/scan1-fn" type="xs:string" />,
    <xf:bind id="Q_ScanCertificate1Up" nodeset="instance('prop')/scan1" type="xs:boolean" relevant="instance('data')/uploads/scan1-fn/text() != ''" />,
    <xf:bind id="Q_ScanCertificate2FileName" nodeset="instance('data')/uploads/scan2-fn" type="xs:string" />,
    <xf:bind id="Q_ScanCertificate2Up" nodeset="instance('prop')/scan2" type="xs:boolean" relevant="instance('data')/uploads/scan2-fn/text() != ''" />,
    <xf:bind id="Q_ScanCertificateDoctoralDegreeFileName" nodeset="instance('data')/uploads/scan-doctoral-fn" type="xs:string" />,
    <xf:bind id="Q_ScanCertificateDoctoralDegreeUp" nodeset="instance('prop')/scan-doctoral" type="xs:boolean" relevant="instance('data')/uploads/scan-doctoral-fn/text() != '' and instance('data')/content/m:properties/d:Q_DoctoralDegree = 'true'" />,
    <xf:bind id="Q_ScanPhotoIDFileName" nodeset="instance('data')/uploads/id-fn" type="xs:string" />,
    <xf:bind id="Q_ScanPhotoIDUp" nodeset="instance('prop')/id" type="xs:boolean" relevant="instance('data')/uploads/id-fn/text() != ''" />,

    <xf:bind id="trigger-disabled" nodeset="instance('prop')/trigger" readonly="instance('prop')/readonly-self = 'true'" />,

    <xf:submission id="save-oa" resource="/restxq/open-application/save" method="post" replace="instance" relevant="false" validate="false">
      <xf:action ev:event="xforms-submit-error">
        <script type="text/javascript">
          $('#label-wait').hide();
          $('#label-error').fadeIn(300).delay(3000).fadeOut(300);
        </script>
      </xf:action>
      <xf:action ev:event="xforms-submit-done">
        <xf:setvalue ref="instance('data')/uploads/scan-ID-change">false</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/scan1-change">false</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/scan2-change">false</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/scan-doctoral-change">false</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/recc1-change">false</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/recc2-change">false</xf:setvalue>
        <script type="text/javascript">
          fluxProcessor.isDirty = false;
          $('#label-wait').hide();
          $('#label-success').fadeIn(300).delay(3000).fadeOut(300);
        </script>
      </xf:action>
    </xf:submission>,
    <xf:submission id="submit-oa" resource="/restxq/open-application/submit" method="post" replace="instance" relevant="false" validate="true">
      <xf:action ev:event="xforms-submit-error">
        <xf:message level="ephemeral">Your form could not be saved. Please check all sections for errors.</xf:message>
       <script type="text/javascript">
          $('#label-wait').hide();
          $('#label-error').fadeIn(300).delay(3000).fadeOut(300);
        </script>

      </xf:action>
      <xf:action ev:event="xforms-submit-done">
        <xf:setvalue ref="instance('prop')/readonly-self">true</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/scan-ID-change">false</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/scan1-change">false</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/scan2-change">false</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/scan-doctoral-change">false</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/recc1-change">false</xf:setvalue>
        <xf:setvalue ref="instance('data')/uploads/recc2-change">false</xf:setvalue>
        <script type="text/javascript">
          fluxProcessor.isDirty = false;
          $('#label-submitted').fadeIn(300).delay(3000).fadeOut(300);
        </script>
      </xf:action>
    </xf:submission>
  )
};


declare %private function _:application-pre($meetings as node())
{
  let $countries := ex:get(odata:get-url( map {
    "Table" := "NAPERSCountries",
    "$orderby" := "Country",
    "NAPERSCountriesSubUnits" := map { }
  }))/*:feed/*:entry
  return (
    <xf:instance xmlns="" id="data">
     <data> <m:properties xmlns="http://www.w3.org/2005/Atom" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices">
        <d:A_Country xsi:nil="true" />
        <d:P_NationalitySame xsi:nil="true" />
        <d:P_CountryNoAP xsi:nil="true" />
        <d:P_OnlySameNationality xsi:nil="true" />
        <d:P_CountryWithAP xsi:nil="true" />
        <d:P_Institution xsi:nil="true" />
        <d:P_InstitutionKnown xsi:nil="true" />
        <d:P_InstitutionUnknown xsi:nil="true" />
	{
	  if (count($meetings/*:ID) > 1) then
	    <d:ID_Meeting xsi:nil="true" />
	  else
            <d:ID_Meeting>{$meetings[1]/*:ID/text()}</d:ID_Meeting>
	}
      </m:properties></data>
    </xf:instance>,
    <xf:instance id="meetings" xmlns="">
      <data>
	{
	  for $meeting in $meetings
	  return <meeting>
		   <label>{$meeting/*:M_MeetingNameFull/text() || " (" || $meeting/*:M_Discipline/text() || ")"}</label>
		   <value>{$meeting/*:ID/text()}</value>
		   <oa>
		   {
		     if (xs:dateTime($meeting/*:YR_OpenApplicationStartDate) le current-dateTime() and xs:dateTime($meeting/*:YR_OpenApplicationEndDate) ge current-dateTime()) then
			"true"
		     else
			"false"
		   }
		   </oa>
		 </meeting>
	}
      </data>
    </xf:instance>,
    <xf:instance id="URL-container" xmlns="">
      <URL/>
    </xf:instance>,
    <xf:instance xmlns="" id="countries">
      <countries>{
        for $m in $countries
        let $v := $m/*:content/*:properties
        return
          <item>
            <label>{$v/*:Country/text()}</label>
            <value>{$v/*:CountryCode/text()}</value>
            <text>{$v/*:InfoText/text()}</text>
          </item>
      }</countries>
    </xf:instance>,
    <xf:instance xmlns="" id="countries-with-ap">
      <countries-with-ap>{
        for $m in $countries[*:content/*:properties/*:Status/text() != "Open Application"]
        let $v := $m/*:content/*:properties
        return
          <item>
            <label>{$v/*:Country/text()}</label>
            <value>{$v/*:CountryCode/text()}</value>
          </item>
      }</countries-with-ap>
    </xf:instance>,
    <xf:instance xmlns="" id="countries-with-subunits">
      <countries-with-subunits>{
        for $m in $countries[*:content/*:properties/*:Status/text() = "Show SubUnits"]
        let $v := $m/*:content/*:properties
        return
          <item>
            <label>{$v/*:Country/text()}</label>
            <value>{$v/*:CountryCode/text()}</value>
          </item>
      }</countries-with-subunits>
    </xf:instance>,
    <xf:instance xmlns="" id="institutes">
      <institutes>
      {
        for $country in $countries[*:content/*:properties/*:Status/text() = "Show SubUnits"]
        for $institute in $country/*:link/*:inline/*:feed/*:entry/*:content/*:properties[*:Status != "Do Not Show SubUnit"]
        order by $institute/*:SubUnit/text()
        return
          <item country="{$country/*:content/*:properties/*:CountryCode/text()}">
            <SubUnit>{$institute/*:SubUnit/text()}</SubUnit>
            <InfoText>{$institute/*:InfoText/text()}</InfoText>
          </item>
      }
        <item country="extra">
          <SubUnit>Other</SubUnit>
          <InfoText>Other</InfoText>
        </item>
      </institutes>
    </xf:instance>,
    <xf:instance xmlns="" id="extra">
	<data>
	  <valid />
	  <invalid />
	</data>
    </xf:instance>,

    <xf:bind id="OA_valid" nodeset="instance('extra')/valid" type="xs:string" relevant="instance('meetings')/meeting[value = instance('data')/m:properties/d:ID_Meeting]/oa = 'true'" />,
    <xf:bind id="OA_invalid" nodeset="instance('extra')/invalid" type="xs:string" relevant="instance('meetings')/meeting[value = instance('data')/m:properties/d:ID_Meeting]/oa = 'false'" />,
    <xf:bind id="Meeting" nodeset="m:properties/d:ID_Meeting" type="xs:string" />,
    <xf:bind id="A_Country" nodeset="m:properties/d:A_Country" type="xs:string" relevant="instance('data')/m:properties/d:ID_Meeting != ''" />,
    <xf:bind id="P_NationalitySame" nodeset="m:properties/d:P_NationalitySame" type="xs:boolean" relevant="instance('countries-with-ap')/item[value = instance('data')/m:properties/d:A_Country] and instance('data')/m:properties/d:A_Country != 'DE' and instance('data')/m:properties/d:ID_Meeting != ''" />,
    <xf:bind id="P_CountryNoAP" nodeset="m:properties/d:P_CountryNoAP" type="xs:boolean" relevant="not(instance('countries-with-ap')/item[value = instance('data')/m:properties/d:A_Country]) and /data/m:properties/d:A_Country != '' and instance('data')/m:properties/d:ID_Meeting != ''" />,
    <xf:bind id="P_OnlySameNationality" nodeset="m:properties/d:P_OnlySameNationality" type="xs:boolean" relevant="instance('countries-with-ap')/item[value = instance('data')/m:properties/d:A_Country] and /data/m:properties/d:P_NationalitySame = 'false' and instance('data')/m:properties/d:ID_Meeting != ''" />,
    <xf:bind id="P_CountryWithAP" nodeset="m:properties/d:P_CountryWithAP" type="xs:boolean" relevant="instance('countries-with-ap')/item[value = instance('data')/m:properties/d:A_Country] and /data/m:properties/d:P_NationalitySame = 'true' and not(instance('countries-with-subunits')/item[value = instance('data')/m:properties/d:A_Country]) and instance('data')/m:properties/d:ID_Meeting != ''" />,
    <xf:bind id="P_Institution" nodeset="m:properties/d:P_Institution" type="xs:string" relevant="instance('countries-with-ap')/item[value = instance('data')/m:properties/d:A_Country] and (/data/m:properties/d:P_NationalitySame = 'true' or instance('data')/m:properties/d:A_Country = 'DE') and instance('countries-with-subunits')/item[value = instance('data')/m:properties/d:A_Country] and instance('data')/m:properties/d:ID_Meeting != ''" />,
    <xf:bind id="P_InstitutionKnown" nodeset="m:properties/d:P_InstitutionKnown" type="xs:boolean" relevant="instance('countries-with-ap')/item[value = instance('data')/m:properties/d:A_Country] and (/data/m:properties/d:P_NationalitySame = 'true' or instance('data')/m:properties/d:A_Country = 'DE') and /data/m:properties/d:P_Institution != 'Other' and /data/m:properties/d:P_Institution != '' and instance('data')/m:properties/d:ID_Meeting != ''" />,
    <xf:bind id="P_InstitutionUnknown" nodeset="m:properties/d:P_InstitutionUnknown" type="xs:boolean" relevant="instance('countries-with-ap')/item[value = instance('data')/m:properties/d:A_Country] and (/data/m:properties/d:P_NationalitySame = 'true' or instance('data')/m:properties/d:A_Country = 'DE') and /data/m:properties/d:P_Institution = 'Other' and instance('data')/m:properties/d:ID_Meeting != ''" />,

    <xf:submission id="oa" resource="/restxq/open-application/main" method="post" replace="none">
    </xf:submission>
  )
};
