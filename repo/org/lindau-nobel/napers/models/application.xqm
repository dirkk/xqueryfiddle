module namespace _ = "http://napers.lindau-nobel.org/models/application";

import module namespace C = "http://lindau-nobel.org/constants";
import module namespace util = "http://napers.lindau-nobel.org/util";
import module namespace session = "http://basex.org/modules/web/session";
import module namespace tmpl = "http://napers.lindau-nobel.org/tmpl";
import module namespace ex = "http://lindau-nobel.org/exchange";
import module namespace perm = "http://napers.lindau-nobel.org/permissions";
import module namespace odata = "http://lindau-nobel.org/OData";

declare namespace xf = "http://www.w3.org/2002/xforms";
declare namespace ev = "http://www.w3.org/2001/xml-events";

declare namespace d = "http://schemas.microsoft.com/ado/2007/08/dataservices";
declare namespace m = "http://schemas.microsoft.com/ado/2007/08/dataservices/metadata";

declare variable $_:co := "http://schemas.microsoft.com/ado/2007/08/dataservices/related/ContactOptions";
declare variable $_:qualifications := "http://schemas.microsoft.com/ado/2007/08/dataservices/related/Qualifications";

declare %private function _:nominee(
  $uuid as xs:string,
  $company-id as xs:string,
  $meeting-id as xs:string,
  $nominations-support-id as xs:string
) {
  let $nominee :=
    try {
      ex:get(odata:get-url( map {
        "Table" := "Nominations",
        "ID" := $uuid
      }))/*:entry/*:content/*:properties
    } catch * {
      ()
    }
  let $person :=
    try {
      ex:get(odata:get-url( map {
        "Table" := "Persons",
        "ID" := $nominee/*:ID_YR/text()
      }))/*:entry/*:content/*:properties
    } catch * {
      ()
    }
  return (
    <xf:instance xmlns="" id="data">
     <data>
       <person>
         <m:properties xmlns="http://www.w3.org/2005/Atom" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices">
          { for $field in $perm:fields-nominee
            let $f := $person/*[local-name() = $field]
            return
              if ($f) then
                if($f[@*:type="Edm.Boolean" and @*:null="true"]) then element {name($f)} {"false"}
                else $f
              else
                element {"d:" || $field} {attribute {"xsi:nil"} {"true"}}
          }
          <d:ID m:type="Edm.Guid">{
            if ($person/*:ID/text() != "") then
              $person/*:ID/text()
            else
              $uuid
          }</d:ID>
        </m:properties>
      </person>
      <nominee>
         <m:properties xmlns="http://www.w3.org/2005/Atom" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices">
          { for $field in $perm:fields-nominee2
            let $f := $nominee/*[local-name() = $field]
            return
              if ($f) then
                if($f[@*:type="Edm.Boolean" and @*:null="true"]) then element {name($f)} {"false"}
                else $f
              else
                element {"d:" || $field} {attribute {"xsi:nil"} {"true"}}
          }
          <d:ID_YR m:type="Edm.Guid">{
            if ($nominee/*:ID_YR/text() != "") then
              $nominee/*:ID_YR/text()
            else
              $uuid
          }</d:ID_YR>
          <d:ID m:type="Edm.Guid">{
            if ($nominee/*:ID/text() != "") then
              $nominee/*:ID/text()
            else
              random:uuid()
          }</d:ID>
          <d:ID_Meeting m:type="Edm.Guid">{
            if ($nominee/*:ID_Meeting/text() != "") then
              $nominee/*:ID_Meeting/text()
            else
              $meeting-id
          }</d:ID_Meeting>
          {
            if ($nominee/*:YR_StatusNomination/text() != '') then
              $nominee/*:YR_StatusNomination
            else
              <d:YR_StatusNomination>Submission Pending</d:YR_StatusNomination>
          }
          <d:ID_Companies m:type="Edm.Guid">{
            if ($nominee/*:ID_Companies/text() != "") then
              $nominee/*:ID_Companies/text()
            else
              $company-id
          }</d:ID_Companies>
        </m:properties>
      </nominee>
      <extra>
        <new>{
          if ($nominee/*:ID/text() != "") then
            "false"
          else
            "true"
        }</new>
        <ID_NominationsSupport>{$nominations-support-id}</ID_NominationsSupport>
      </extra>
      <uploads>
        <d:YR_Recommendation1Letter />
        <recc1-change>false</recc1-change>
          {
            if ($nominee/*:ID_Recommendation1Letter/text()) then
              <recc1-fn>{ex:get(odata:get-url( map {
                "Table" := "DocumentsUser",
                "ID" := $nominee/*:ID_Recommendation1Letter/text()
              }))/*:entry/*:content/*:properties/*:FileName/text()}</recc1-fn>
            else
              <recc1-fn xsi:nil="true" />
          }
        </uploads>
      </data>
    </xf:instance>,
    <xf:instance xmlns="" id="prop">
      <data>
        <recc1 xsi:nil="true" />
        <readonly>{
          if ($nominee/*:YR_NominationByAPComplete = "true") then
            "true"
          else
            "false"
        }</readonly>
      </data>
    </xf:instance>,

    <xf:bind id="P_NameFirst" nodeset="person/m:properties/d:P_NameFirst" readonly="instance('prop')/readonly = 'true'" required="true()" type="xs:string" />,
    <xf:bind id="P_NameMiddle" nodeset="person/m:properties/d:P_NameMiddle" readonly="instance('prop')/readonly = 'true'" type="xs:string" />,
    <xf:bind id="P_NameLastPre" nodeset="person/m:properties/d:P_NameLastPre" readonly="instance('prop')/readonly = 'true'" type="xs:string" />,
    <xf:bind id="P_NameLast" nodeset="person/m:properties/d:P_NameLast" readonly="instance('prop')/readonly = 'true'" required="true()" type="xs:string" />,
    <xf:bind id="P_TitleAcademicPre" nodeset="person/m:properties/d:P_TitleAcademicPre" readonly="instance('prop')/readonly = 'true'" type="xs:string" />,
    <xf:bind id="P_TitleAcademicPost" nodeset="person/m:properties/d:P_TitleAcademicPost" readonly="instance('prop')/readonly = 'true'" type="xs:string" />,
    <xf:bind id="C_EmailPrivate" nodeset="person/m:properties/d:C_EmailPrivate" readonly="instance('prop')/readonly = 'true'" required="true()" type="xs:string" constraint="matches(., '[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]+')" />,

    <xf:bind id="YR_Recommendation1Letter" nodeset="uploads/d:YR_Recommendation1Letter" readonly="instance('prop')/readonly = 'true'" type="xs:anyURI" relevant="not(instance('data')/uploads/recc1-fn/text())" />,
    <xf:bind id="YR_Recommendation1Institution" nodeset="nominee/m:properties/d:YR_Recommendation1Institution" readonly="instance('prop')/readonly = 'true'" type="xs:string" required="instance('data')/uploads/recc1-fn/text() != ''" />,
    <xf:bind id="YR_Recommendation1By" nodeset="nominee/m:properties/d:YR_Recommendation1By" readonly="instance('prop')/readonly = 'true'" type="xs:string" required="instance('data')/uploads/recc1-fn/text() != ''" />,
    <xf:bind id="YR_RecommendationLetter1Visible" nodeset="nominee/m:properties/d:YR_RecommendationLetter1Visible" readonly="instance('prop')/readonly = 'true'" type="xs:boolean" />,
    <xf:bind id="YR_Recommendation3" nodeset="nominee/m:properties/d:YR_Recommendation3" readonly="instance('prop')/readonly = 'true'" type="xs:string" constraint="string-length(.) &lt; 4000" />,
    <xf:bind id="YR_Recommendation3Institution" nodeset="nominee/m:properties/d:YR_Recommendation3Institution" readonly="instance('prop')/readonly = 'true'" required="string-length(instance('data')/nominee/m:properties/d:YR_Recommendation3) &gt; 0" type="xs:string" />,
    <xf:bind id="YR_Recommendation3By" nodeset="nominee/m:properties/d:YR_Recommendation3By" readonly="instance('prop')/readonly = 'true'" required="string-length(instance('data')/nominee/m:properties/d:YR_Recommendation3) &gt; 0" type="xs:string" />,
    <xf:bind id="YR_RecommendationLetter3Visible" nodeset="nominee/m:properties/d:YR_RecommendationLetter3Visible" readonly="instance('prop')/readonly = 'true'" type="xs:boolean" />,
    <xf:bind nodeset="instance('data')/nominee/*:properties/d:AP_Comment" id="AP_Comment"/>,

    (: required for file upload :)
    <xf:bind id="YR_Recommendation1LetterFileName" nodeset="instance('data')/uploads/recc1-fn" readonly="instance('prop')/readonly = 'true'" type="xs:string" />,
    <xf:bind id="YR_Recommendation1LetterUp" nodeset="instance('prop')/recc1" type="xs:boolean" readonly="instance('prop')/readonly = 'true'" relevant="instance('data')/uploads/recc1-fn/text() != ''" />,

    <xf:submission id="save-nominee" resource="/restxq/napers/ap-kp/save-nominee" method="post" replace="none" validate="false" relevant="false">
      <xf:action ev:event="xforms-submit-error">
        <script type="text/javascript">
          $('#label-error').fadeIn(300).delay(3000).fadeOut(300);
        </script>
      </xf:action>
      <xf:action ev:event="xforms-submit-done">
        <script type="text/javascript">
          fluxProcessor.isDirty = false;
          window.location = '/restxq/napers/ap-kp?c={$company-id}';
        </script>
      </xf:action>
    </xf:submission>
  )
};

declare %private function _:append-nil(
  $node
) {
  <m:properties xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{(
  $node/*[not(exists(@m:null))],
  for $c in $node/*[@m:null = "true"]
  return
    copy $copy := $c
    modify insert node (attribute {"xsi:nil"} {"true"}) into $copy
    return $copy
  )}</m:properties>
};

declare %private function _:applicant-sr(
  $review-id as xs:string,
  $person-id as xs:string,
  $request
) {
  let $review := ex:get(odata:get-url( map {
    "Table" := "Reviews",
    "ID" := $review-id
  }))/*:entry/*:content/*:properties
  let $person := _:append-nil($request/*:entry/*:content/*:properties)
  let $nominee := _:append-nil($request/*:entry/*:link[@*:title = 'NominationsYR']/*:inline/*:feed/*:entry/*:content/*:properties)
  let $company := $request/*:entry/*:link[@*:title = 'NominationsYR']/*:inline/*:feed/*:entry/*:link[@*:title = 'Company']/*:inline/*:entry/*:content/*:properties
  let $participation := _:append-nil($request/*:entry/*:link[@*:title = 'MeetingParticipation']/*:inline/*:feed/*:entry/*:content/*:properties)
  let $qualifications := $request/*:entry/*:link[@*:title = 'Qualifications']/*:inline
  let $contact-options := _:append-nil($request/*:entry/*:link[@*:title = 'ContactOptions']/*:inline)
  let $fields := map:keys($perm:fields-rights)
  let $uuid := $person/*:ID
  let $countries := ex:get(odata:get-url( map {
    "Table" := "NAPERSCountries",
    "$orderby" := "Country"
  }))/*:feed/*:entry/*:content/*:properties
  return (
    <xf:model id="main" xlmns="">{(
    <xf:instance xmlns="" id="data">
      <data>
        <application>
        <person>
          <m:properties>
          {
            for $p in $person/*
            where map:contains($perm:fields-rights, local-name($p)) and
              map:get($perm:fields-rights(local-name($p)), "group") = (0, 1, 2, 3, 4, 7) and not(local-name($p) = ("P_CountryOfBirth", "P_Nationality", "A_Country", "A2_Country"))
            return $p
          }
            <d:P_CountryOfBirth>{$C:CC($person/*:P_CountryOfBirth)}</d:P_CountryOfBirth>
            <d:P_Nationality>{$C:CC($person/*:P_Nationality)}</d:P_Nationality>
            <d:A_Country>{$C:CC($person/*:A_Country)}</d:A_Country>
            <d:A2_Country>{$C:CC($person/*:A2_Country)}</d:A2_Country>
          </m:properties>
         </person>
       <nominee>
        <m:properties>
        {
            for $p in $nominee/*
            where (map:contains($perm:fields-rights, local-name($p)) and
              map:get($perm:fields-rights(local-name($p)), "group") = (0, 1, 2, 3, 4, 7))
              or local-name($p) = ("ID_Meeting", "ID_Recommendation1Letter", "ID_Recommendation2Letter",
                "YR_MainProfileDataSubmitted",
                "YR_TravelBoardingLodingDataSubmitted", "YR_PublicDirectoryDataSubmitted")
            return $p
        }
        </m:properties>
       </nominee>
        <uploads>
          {
            if ($nominee/*:ID_Recommendation1Letter/text()) then
        let $doc := ex:get(replace($C:DOCUMENTS-USER-URL, "__GUID__", $nominee/*:ID_Recommendation1Letter/text()))/*:entry/*:content/*:properties
        return (
    <d:YR_Recommendation1Letter>{$C:BASE-URL || "/restxq/file/" || $doc/*:ID/text()}</d:YR_Recommendation1Letter>,
    <d:YR_Recommendation1LetterFileName>{$doc/*:FileName/text()}</d:YR_Recommendation1LetterFileName>
        )
            else
              <d:YR_Recommendation1Letter />
          }
    <d:YR_Recommendation1LetterNot />
          {
            if ($nominee/*:ID_Recommendation2Letter/text()) then
        let $doc := ex:get(replace($C:DOCUMENTS-USER-URL, "__GUID__", $nominee/*:ID_Recommendation2Letter/text()))/*:entry/*:content/*:properties
        return (
    <d:YR_Recommendation2Letter>{$C:BASE-URL || "/restxq/file/" || $doc/*:ID/text()}</d:YR_Recommendation2Letter>,
    <d:YR_Recommendation2LetterFileName>{$doc/*:FileName/text()}</d:YR_Recommendation2LetterFileName>
        )
            else
              <d:YR_Recommendation2Letter />
          }
    <d:YR_Recommendation2LetterNot />
        </uploads>
      <qualifications>
        {
          copy $copy := $qualifications
          modify (
            for $e in $copy/*:feed/*:entry/*:content/*:properties/*:YR_QualificationStartDate
            return replace value of node $e with substring($e/text(), 1, 10),
            for $e in $copy/*:feed/*:entry/*:content/*:properties/*:YR_QualificationEndDate
            return replace value of node $e with substring($e/text(), 1, 10),
            for $e in $copy/*:feed/*:entry/*:content/*:properties/*:YR_QualificationInstitutionCountry
            return replace value of node $e with $C:CC($e)
          )
          return $copy
        }
      </qualifications>
      </application>
    </data>
    </xf:instance>,
    <xf:instance id="extra" xmlns="">
      <data>
      {
        (: Calculate the birthday :)
        if ($person/*:P_DateOfBirth/text() != "") then (
          <DateOfBirth>
          {
            let $day := day-from-dateTime($person/*:P_DateOfBirth)
            let $month := month-from-dateTime($person/*:P_DateOfBirth)
            let $year := year-from-dateTime($person/*:P_DateOfBirth)
            return $day || "." || $month || "." || $year
          }
          </DateOfBirth>
        ) else (
          <DateOfBirth xsi:nil="true" />
        )
      }
        <editable>
          <main>false</main>
          <main-2 />
          <evaluation>true</evaluation>
        </editable>
        <Nominator>
          <Company>{
            if ($company/*:C_CompanyName1English/text() != '')
            then $company/*:C_CompanyName1English/text()
            else "Unknown"
          }</Company>
          <Country>{
            if ($company/*:C_Country/text() != '')
            then $company/*:C_Country/text()
            else "Unknown"
          }</Country>
          <Comment>{
            if ($nominee/*:AP_Comment/text() != '')
            then $nominee/*:AP_Comment/text()
            else "None"
          }</Comment>
        </Nominator>
      </data>
    </xf:instance>,

    (: Personal Data :)
    <xf:bind id="P_NameFirst" nodeset="application/person/m:properties/d:P_NameFirst" type="xs:string" />,
    <xf:bind id="P_NameMiddle" nodeset="application/person/m:properties/d:P_NameMiddle" type="xs:string" />,
    <xf:bind id="P_NameLastPre" nodeset="application/person/m:properties/d:P_NameLastPre" type="xs:string" />,
    <xf:bind id="P_NameLast" nodeset="application/person/m:properties/d:P_NameLast" type="xs:string" />,
    <xf:bind id="P_TitleAcademicPre" nodeset="application/person/m:properties/d:P_TitleAcademicPre" type="xs:string" />,
    <xf:bind id="P_TitleAcademicPost" nodeset="application/person/m:properties/d:P_TitleAcademicPost" type="xs:string" />,
    <xf:bind id="P_Gender" nodeset="application/person/m:properties/d:P_Gender" type="xs:string" />,
    <xf:bind id="P_DateOfBirth" nodeset="instance('extra')/DateOfBirth" type="xs:string" />,
    <xf:bind id="P_CountryOfBirth" nodeset="application/person/m:properties/d:P_CountryOfBirth" type="xs:string" />,
    <xf:bind id="P_Nationality" nodeset="application/person/m:properties/d:P_Nationality" type="xs:string" />,

    (: Addresses :)
    <xf:bind id="A2_Street" nodeset="application/person/m:properties/d:A2_Street" type="xs:string" />,
    <xf:bind id="A2_Street2" nodeset="application/person/m:properties/d:A2_Street2" type="xs:string" />,
    <xf:bind id="A2_CompanyLocation" nodeset="application/person/m:properties/d:A2_CompanyLocation" type="xs:string" />,
    <xf:bind id="A2_PostalCodePre" nodeset="application/person/m:properties/d:A2_PostalCodePre" type="xs:string" />,
    <xf:bind id="A2_PostalCodePost" nodeset="application/person/m:properties/d:A2_PostalCodePost" type="xs:string" />,
    <xf:bind id="A2_City" nodeset="application/person/m:properties/d:A2_City" type="xs:string" />,
    <xf:bind id="A2_State" nodeset="application/person/m:properties/d:A2_State" type="xs:string" />,
    <xf:bind id="A2_Country" nodeset="application/person/m:properties/d:A2_Country" type="xs:string" />,
    <xf:bind id="C_PhonePrivateFixed" nodeset="application/person/m:properties/d:C_PhonePrivateFixed" type="xs:string" />,
    <xf:bind id="C_PhonePrivateMobile" nodeset="application/person/m:properties/d:C_PhonePrivateMobile" type="xs:string" />,
    <xf:bind id="C_EmailPrivate" nodeset="application/person/m:properties/d:C_EmailPrivate" type="xs:string" />,
    <xf:bind id="C_Website" nodeset="application/person/m:properties/d:C_Website" type="xs:string" />,

    <xf:bind id="A_Company1" nodeset="application/person/m:properties/d:A_Company1" type="xs:string" />,
    <xf:bind id="A_Company2" nodeset="application/person/m:properties/d:A_Company2" type="xs:string" />,
    <xf:bind id="A_Department" nodeset="application/person/m:properties/d:A_Department" type="xs:string" />,
    <xf:bind id="A_Street" nodeset="application/person/m:properties/d:A_Street" type="xs:string" />,
    <xf:bind id="A_Street2" nodeset="application/person/m:properties/d:A_Street2" type="xs:string" />,
    <xf:bind id="A_CompanyLocation" nodeset="application/person/m:properties/d:A_CompanyLocation" type="xs:string" />,
    <xf:bind id="A_PostalCodePre" nodeset="application/person/m:properties/d:A_PostalCodePre" type="xs:string" />,
    <xf:bind id="A_PostalCodePost" nodeset="application/person/m:properties/d:A_PostalCodePost" type="xs:string" />,
    <xf:bind id="A_City" nodeset="application/person/m:properties/d:A_City" type="xs:string" />,
    <xf:bind id="A_State" nodeset="application/person/m:properties/d:A_State" type="xs:string" />,
    <xf:bind id="A_Country" nodeset="application/person/m:properties/d:A_Country" type="xs:string" />,
    <xf:bind id="C_PhoneBusinessFixed" nodeset="application/person/m:properties/d:C_PhoneBusinessFixed" type="xs:string" />,
    <xf:bind id="C_PhoneBusinessMobile" nodeset="application/person/m:properties/d:C_PhoneBusinessMobile" type="xs:string" />,
    <xf:bind id="C_EmailBusiness" nodeset="application/person/m:properties/d:C_EmailBusiness" type="xs:string" />,

    (: Recommendations :)
    <xf:bind id="YR_Recommendation1Institution" nodeset="application/nominee/m:properties/d:YR_Recommendation1Institution" type="xs:string" />,
    <xf:bind id="YR_Recommendation1By" nodeset="application/nominee/m:properties/d:YR_Recommendation1By" type="xs:string" />,
    <xf:bind id="YR_Recommendation2Institution" nodeset="application/nominee/m:properties/d:YR_Recommendation2Institution" type="xs:string" />,
    <xf:bind id="YR_Recommendation2By" nodeset="application/nominee/m:properties/d:YR_Recommendation2By" type="xs:string" />,
    <xf:bind id="YR_Recommendation3" nodeset="application/nominee/m:properties/d:YR_Recommendation3" type="xs:string" />,
    <xf:bind id="YR_Recommendation3Institution" nodeset="application/nominee/m:properties/d:YR_Recommendation3Institution" type="xs:string" />,
    <xf:bind id="YR_Recommendation3By" nodeset="application/nominee/m:properties/d:YR_Recommendation3By" type="xs:string" />,

    (: Qualifications :)
    <xf:bind id="YR_QualificationStartDate" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationStartDate" type="xs:string" />,
    <xf:bind id="YR_QualificationEndDate" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/m:properties/d:YR_QualificationEndDate" type="xs:string" />,

    <xf:bind id="YR_QualificationDegreeName" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/m:properties/d:YR_QualificationDegreeName" type="xs:string" />,
    <xf:bind id="YR_QualificationDegreeType" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationDegreeType" type="xs:string" />,
    <xf:bind id="YR_QualificationDegreeMajor" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationDegreeMajor" type="xs:string" />,
    <xf:bind id="YR_QualificationGradeAchieved" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationGradeAchieved" type="xs:string" />,
    <xf:bind id="YR_QualificationWorstGradeOcScale" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationWorstGradeOcScale" type="xs:string" />,
    <xf:bind id="YR_QualificationBestGradeOnScale" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationBestGradeOnScale" type="xs:string" />,

   <xf:bind id="YR_QualificationPublicationType" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationType" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationAuthor1" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationAuthor1" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationAuthor2" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationAuthor2" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationAuthor3" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationAuthor3" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationNumberOfAuthors"
      nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationNumberOfAuthors"
      type="xs:decimal"
      />,
    <xf:bind id="YR_QualificationPublicationFirstAuthor" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationFirstAuthor" type="xs:boolean" readonly="true" />,
    <xf:bind id="YR_QualificationPublicationTitle" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationTitle" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationJournal" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationJournal" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationVolume" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationVolume" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationIssue" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationIssue" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationPages" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationPages" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationKeywords" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationKeywords" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationURL" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationURL" type="xs:string" />,
    <xf:bind id="YR_QualificationPublicationDOI" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationPublicationDOI" type="xs:string" />,

    <xf:bind id="YR_QualificationResearchExperiencePosition" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationResearchExperiencePosition" type="xs:string" />,
    <xf:bind id="YR_QualificationResearchExperienceDescription" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationResearchExperienceDescription" type="xs:string" />,

    <xf:bind id="YR_QualificationAwardName" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationAwardName" type="xs:string" />,
    <xf:bind id="YR_QualificationAwardDescription" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationAwardDescription" type="xs:string" />,

    <xf:bind id="YR_QualificationConferencePresentationType" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationConferencePresentationType" type="xs:string" />,
    <xf:bind id="YR_QualificationConferencePresentationTitle" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationConferencePresentationTitle" type="xs:string" />,
    <xf:bind id="YR_QualificationConferencePresentationDescription" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationConferencePresentationDescription" type="xs:string" />,

    <xf:bind id="YR_QualificationTutoringExperienceSubject" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationTutoringExperienceSubject" type="xs:string" />,
    <xf:bind id="YR_QualificationTutoringExperienceDescription" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationTutoringExperienceDescription" type="xs:string" />,
    <xf:bind id="YR_QualificationTutoringExperienceEngagement" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationtutoringExperienceEngagement" type="xs:string" />,
    <xf:bind id="YR_QualificationTutoringExperienceExtent" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationTutoringExperienceExtend" type="xs:string" />,

    <xf:bind id="YR_QualificationLanguage" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationLanguage" type="xs:string" />,
    <xf:bind id="YR_QualificationLanguageListeningLevel" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationLanguageListeningLevel" type="xs:string" />,
    <xf:bind id="YR_QualificationLanguageSpeakingLevel" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationLanguageSpeakingLevel" type="xs:string" />,

    <xf:bind id="YR_QualificationInstitutionName" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationInstitutionName" type="xs:string" />,
    <xf:bind id="YR_QualificationInstitutionCity" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationInstitutionCity" type="xs:string" />,
    <xf:bind id="YR_QualificationInstitutionCountry" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationInstitutionCountry" type="xs:string" />,
    <xf:bind id="YR_QualificationInstitutionWebsite" nodeset="instance('data')/application/qualifications/*:inline/*:feed/*:entry/*:content/m:properties/d:YR_QualificationInstitutionWebsite" type="xs:string" />,

    (: Motivation :)
    <xf:bind id="YR_Motivation" nodeset="application/nominee/m:properties/d:YR_Motivation" type="xs:string" />,
    <xf:bind id="YR_Remarks" nodeset="application/nominee/m:properties/d:YR_Remarks" type="xs:string" />,

    (: Final Checks :)
    <xf:bind id="YR_CheckTermsCondition" nodeset="application/nominee/m:properties/d:YR_CheckTermsConditions" type="xs:boolean" readonly="{_:element-readonly("YR_CheckTermsCondition")} or instance('extra')/editable/main = 'false'" required="not({_:element-readonly("YR_CheckTermsCondition")} or instance('extra')/editable/main = 'false')" />,
    <xf:bind id="YR_CheckPrivacyPolicy" nodeset="application/nominee/m:properties/d:YR_CheckPrivacyPolicy" type="xs:boolean" readonly="{_:element-readonly("YR_CheckPrivacyPolicy")} or instance('extra')/editable/main = 'false'" required="not({_:element-readonly("YR_CheckPrivacyPolicy")} or instance('extra')/editable/main = 'false')" />,
    <xf:bind id="YR_CheckDirectory" nodeset="application/nominee/m:properties/d:YR_CheckDirectory" type="xs:boolean" readonly="{_:element-readonly("YR_CheckDirectory")} or instance('extra')/editable/main = 'false'" required="not({_:element-readonly("YR_CheckDirectory")} or instance('extra')/editable/main = 'false')" />,
    <xf:bind id="YR_CheckDataToSupporters" nodeset="application/nominee/m:properties/d:YR_CheckDataToSupporters" type="xs:boolean" readonly="{_:element-readonly("YR_CheckDataToSupporters")} or instance('extra')/editable/main = 'false'" required="not({_:element-readonly("YR_CheckDataToSupporters")} or instance('extra')/editable/main = 'false')" />,
    <xf:bind id="YR_CheckSupportedByThirdParties" nodeset="application/nominee/m:properties/d:YR_CheckSupportedByThirdParties" type="xs:boolean" readonly="{_:element-readonly("YR_CheckSupportedByThirdParties")} or instance('extra')/editable/main = 'false'" required="not({_:element-readonly("YR_CheckSupportedByThirdParties")} or instance('extra')/editable/main = 'false')" />,

    (: for file uploads :)
    <xf:bind id="YR_Recommendation1Letter" nodeset="instance('data')/application/uploads/d:YR_Recommendation1Letter" type="xs:string" relevant="instance('data')/application/uploads/d:YR_Recommendation1Letter/text() != ''" />,
    <xf:bind id="YR_Recommendation1LetterNot" nodeset="instance('data')/application/uploads/d:YR_Recommendation1LetterNot" type="xs:string" relevant="not(instance('data')/application/uploads/d:YR_Recommendation1Letter/text() != '')" />,
    <xf:bind id="YR_Recommendation2Letter" nodeset="instance('data')/application/uploads/d:YR_Recommendation2Letter" type="xs:string" relevant="instance('data')/application/uploads/d:YR_Recommendation2Letter/text() != ''" />,
    <xf:bind id="YR_Recommendation2LetterNot" nodeset="instance('data')/application/uploads/d:YR_Recommendation2LetterNot" type="xs:string" relevant="not(instance('data')/application/uploads/d:YR_Recommendation2Letter/text() != '')" />,

    (: Nominated by this AP-KP :)
    <xf:bind id="Nominator" type="xs:string" nodeset="instance('extra')/Nominator/Company" />,
    <xf:bind id="Nominator_Country" type="xs:string" nodeset="instance('extra')/Nominator/Country" />,
    <xf:bind id="Nominator_Comment" type="xs:string" nodeset="instance('extra')/Nominator/Comment" />,

    (: visibility binds :)
    <xf:bind id="Visibility_Application" nodeset="instance('extra')/editable/main" type="xs:boolean" relevant="instance('extra')/editable/main = 'true'" />,
    <xf:bind id="Readonly_Application" nodeset="instance('extra')/editable/main-2" type="xs:boolean" readonly="not(instance('extra')/editable/main = 'true')" />

    )}
    </xf:model>,

    (: Evaluation :)
    <xf:model id="evaluation" xmlns="">
    {(
    <xf:instance xmlns="" id="data">
      <data>
        <review>
          {$review/*}
        </review>
        <Pre>
          {
            let $p := ex:get(odata:get-url( map {
              "Table" :="ReviewResultsAveragePre",
              "$filter" := "ID_Nominations%20eq%20guid'" || $nominee/*:ID/text() || "'"
            }))/*:feed/*:entry/*:content/*:properties
            return if (exists($p))
                   then $p/*
                   else (
                     <d:YR_StatusEvaluationOverall_AVG>N/A</d:YR_StatusEvaluationOverall_AVG>,
                     <d:YR_StatusEvaluationCV_AVG>N/A</d:YR_StatusEvaluationCV_AVG>,
                     <d:YR_StatusEvaluationPublications_AVG>N/A</d:YR_StatusEvaluationPublications_AVG>,
                     <d:YR_StatusEvaluationBiggerPicture_AVG>N/A</d:YR_StatusEvaluationBiggerPicture_AVG>)
          }
        </Pre>
        <Avg>
          {
            let $p := ex:get(odata:get-url( map {
              "Table" := "ReviewResultsAverageFinal",
              "$filter" := "ID_Nominations%20eq%20guid'" || $nominee/*:ID/text() || "'"
            }))/*:feed/*:entry/*:content/*:properties
            return if (exists($p))
                   then $p/*
                   else (
                     <d:YR_StatusEvaluationOverall_AVG>N/A</d:YR_StatusEvaluationOverall_AVG>,
                     <d:YR_StatusEvaluationCV_AVG>N/A</d:YR_StatusEvaluationCV_AVG>,
                     <d:YR_StatusEvaluationPublications_AVG>N/A</d:YR_StatusEvaluationPublications_AVG>,
                     <d:YR_StatusEvaluationBiggerPicture_AVG>N/A</d:YR_StatusEvaluationBiggerPicture_AVG>)
          }
        </Avg>
        <nominee>
          <d:ID>{$nominee/*:ID/text()}</d:ID>
          <d:YR_StatusEvaluationReview>{$nominee/*:YR_StatusEvaluationReview/text()}</d:YR_StatusEvaluationReview>
          <d:YR_StatusNomination>{$nominee/*:YR_StatusNomination/text()}</d:YR_StatusNomination>
       </nominee>
      </data>
    </xf:instance>,
    <xf:instance id="extra" xmlns="">
      <data>
        <editable>
          {
            if ($review/*:YR_StatusEvaluationComplete = 'false' or $review/*:YR_StatusEvaluationComplete/@m:null = 'true') then
              <evaluation>true</evaluation>
            else
              <evaluation>false</evaluation>
          }
        </editable>
        <NotVisible>
          <Pre><not-visible/><visible/><value>{if ($nominee/*:YR_EvaluationShowPreReviewResults/text() = 'true') then "true" else "false"}</value></Pre>
          <Avg><not-visible/><visible/><value>{if ($nominee/*:YR_EvaluationShowOtherReviewResults/text() = 'true') then "true" else "false"}</value></Avg>
          <SharedRemark><not-visible/><visible/><value>{if ($nominee/*:YR_EvaluationShowSharedComments/text() = 'true') then "true" else "false"}</value></SharedRemark>
        </NotVisible>
      </data>
    </xf:instance>,

    (: Evaluation :)
    <xf:bind id="YR_SharedRemark" nodeset="instance('data')/nominee/*:YR_StatusEvaluationReview" type="xs:string" readonly="instance('extra')/editable/evaluation = 'false'" />,
    <xf:bind id="YR_StatusEvaluationOverall" nodeset="instance('data')/review/d:YR_StatusEvaluationOverall" type="xs:string" required="true()" readonly="instance('extra')/editable/evaluation = 'false'" constraint=". != ''" />,
    <xf:bind id="YR_StatusEvaluationCV" nodeset="instance('data')/review/d:YR_StatusEvaluationCV" type="xs:string" readonly="instance('extra')/editable/evaluation = 'false'" />,
    <xf:bind id="YR_StatusEvaluationPublications" nodeset="instance('data')/review/d:YR_StatusEvaluationPublications" type="xs:string" readonly="instance('extra')/editable/evaluation = 'false'" />,
    <xf:bind id="YR_StatusEvaluationBiggerPicture" nodeset="instance('data')/review/d:YR_StatusEvaluationBiggerPicture" type="xs:string" readonly="instance('extra')/editable/evaluation = 'false'" />,
    <xf:bind id="YR_StatusEvaluationReview" nodeset="instance('data')/review/d:YR_StatusEvaluationReview" type="xs:string" readonly="instance('extra')/editable/evaluation = 'false'" />,
    <xf:bind id="YR_StatusNomination" nodeset="instance('data')/nominee/*:YR_StatusNomination" type="xs:string" readonly="instance('extra')/editable/evaluation = 'false'" />,

    (: Pre Review :)
    <xf:bind id="Pre_OverallScore" nodeset="instance('data')/Pre/*:YR_StatusEvaluationOverall_AVG" type="xs:string" relevant="instance('data')/Pre/*:YR_StatusEvaluationOverall_AVG/text() != ''" />,
    <xf:bind id="Pre_CV" nodeset="instance('data')/Pre/*:YR_StatusEvaluationCV_AVG" type="xs:string" relevant="instance('data')/Pre/*:YR_StatusEvaluationCV_AVG/text() != ''" />,
    <xf:bind id="Pre_Publications" nodeset="instance('data')/Pre/*:YR_StatusEvaluationPublications_AVG" type="xs:string" relevant="instance('data')/Pre/*:YR_StatusEvaluationPublications_AVG/text() != ''" />,
    <xf:bind id="Pre_BiggerPicture" nodeset="instance('data')/Pre/*:YR_StatusEvaluationBiggerPicture_AVG" type="xs:string" relevant="instance('data')/Pre/*:YR_StatusEvaluationBiggerPicture_AVG/text() != ''" />,

    (: Average scores from other reviewers :)
    <xf:bind id="Avg_OverallScore" nodeset="instance('data')/Avg/*:YR_StatusEvaluationOverall_AVG" type="xs:string" relevant="instance('data')/Avg/*:YR_StatusEvaluationOverall_AVG/text() != ''" />,
    <xf:bind id="Avg_CV" nodeset="instance('data')/Avg/*:YR_StatusEvaluationCV_AVG" type="xs:string" relevant="instance('data')/Avg/*:YR_StatusEvaluationCV_AVG/text() != ''" />,
    <xf:bind id="Avg_Publications" nodeset="instance('data')/Avg/*:YR_StatusEvaluationPublications_AVG" type="xs:string" relevant="instance('data')/Avg/*:YR_StatusEvaluationPublications_AVG/text() != ''" />,
    <xf:bind id="Avg_BiggerPicture" nodeset="instance('data')/Avg/*:YR_StatusEvaluationBiggerPicture_AVG" type="xs:string" relevant="instance('data')/Avg/*:YR_StatusEvaluationBiggerPicture_AVG/text() != ''" />,

    (: visibility binds :)
    <xf:bind id="Visible_Pre" nodeset="instance('extra')/NotVisible/Pre/visible" type="xs:string" relevant="instance('extra')/NotVisible/Pre/value/text() != 'false'" />,
    <xf:bind id="Visible_Avg" nodeset="instance('extra')/NotVisible/Avg/visible" type="xs:string" relevant="instance('extra')/NotVisible/Avg/value/text() != 'false'" />,
    <xf:bind id="Visible_SharedRemark" nodeset="instance('extra')/NotVisible/SharedRemark/visible" type="xs:string" relevant="instance('extra')/NotVisible/SharedRemark/value/text() != 'false'" />,
    <xf:bind id="Invisible_Pre" nodeset="instance('extra')/NotVisible/Pre/not-visible" type="xs:string" relevant="instance('extra')/NotVisible/Pre/value/text() != 'true'" />,
    <xf:bind id="Invisible_Avg" nodeset="instance('extra')/NotVisible/Avg/not-visible" type="xs:string" relevant="instance('extra')/NotVisible/Avg/value/text() != 'true'" />,
    <xf:bind id="Invisible_SharedRemark" nodeset="instance('extra')/NotVisible/SharedRemark/not-visible" type="xs:string" relevant="instance('extra')/NotVisible/SharedRemark/value/text() != 'true'" />,
    <xf:bind id="Visibility_Evaluation" nodeset="instance('extra')/editable/evaluation" type="xs:boolean" readonly="not(instance('extra')/editable/evaluation = 'true')" />,

    <xf:submission id="save-evaluation" resource="/restxq/napers/applicant/save-evaluation" method="post" replace="none" validate="false" relevant="false" >
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
    <xf:submission id="submit-evaluation" resource="/restxq/napers/applicant/submit-evaluation" method="post" replace="none" validate="true" relevant="false">
      <xf:action ev:event="xforms-submit-error">
        <script type="text/javascript">
          $('#label-submit-evaluation-wait').hide();
          $('#label-submit-evaluation-error').fadeIn(300).delay(3000).fadeOut(300);
        </script>
      </xf:action>
      <xf:action ev:event="xforms-submit-done">
        <xf:setvalue ref="instance('extra')/editable/evaluation">false</xf:setvalue>
        <script type="text/javascript">
          fluxProcessor.isDirty = false;
          $('#label-submit-evaluation-wait').hide();
          $('#label-submit-evaluation-success').fadeIn(300).delay(3000).fadeOut(300);
        </script>
      </xf:action>
    </xf:submission>
    )}
    </xf:model>
  )
};


declare %private function _:element-readonly(
  $element as xs:string) as xs:string {
    if (_:element-editable($element) = "true()") then
      "false()"
    else
      "true()"
};

declare %private function _:element-editable(
  $element as xs:string) as xs:string {
  let $role := session:role(),
      $this-field := $perm:fields-rights($element)
  return
    if (empty($this-field)) then
      "true()"
    else
      let $my-field := $this-field($role),
          $editable := $my-field("edit")
      return
        if (empty($editable)) then
          "true()"
        else
          xs:string($editable) || "()"
};

declare %private function _:element-viewable(
  $element as xs:string) as xs:boolean {
  let $role := session:role(),
      $this-field := $perm:fields-rights($element)
  return
    if (empty($this-field)) then
      false()
    else
      let $my-field := $this-field($role),
          $viewable := $my-field("view")
      return
        if (empty($viewable)) then
          false()
        else
          if ($this-field("group") = 0 and true()) then
            true()
          else if ($this-field("group") = 1 and true()) then
            true()
          else if ($this-field("group") = 2 and true()) then
            true()
          else if ($this-field("group") = 3 and true()) then
            true()
          else if ($this-field("group") = 4 and true()) then
            true()
          else if ($this-field("group") = 5 and true()) then
            true()
          else if ($this-field("group") = 6 and true()) then
            true()
          else if ($this-field("group") = 7 and true()) then
            true()
          else
            false()
};

declare %private function _:qualification-template($uuid, $type){
  let $guid := random:uuid()
  return
  <entry xmlns="http://www.w3.org/2005/Atom" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata">
    <category term="LindauNobelCRMModel.Qualifications" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme"/>
    <content type="application/xml">
      <m:properties>
        <d:ID m:type="Edm.Guid">{$guid}</d:ID>
        <d:ID_Persons m:type="Edm.Guid">{$uuid}</d:ID_Persons>
        <d:YR_QualificationStartDate>2012-01-01</d:YR_QualificationStartDate>
        <d:YR_QualificationEndDate>2012-01-01</d:YR_QualificationEndDate>
        <d:YR_QualificationDegreeName m:null="true" />
        <d:YR_QualificationDegreeType m:null="true" />
        <d:YR_QualificationDegreeMajor m:null="true" />
        <d:YR_QualificationType>{$type}</d:YR_QualificationType>
        <d:YR_QualificationGradeAchieved m:null="true" />
        <d:YR_QualificationWorstGradeOcScale m:null="true" />
        <d:YR_QualificationBestGradeOnScale m:null="true" />
        <d:YR_QualificationPublicationType m:null="true" />
        <d:YR_QualificationPublicationAuthor1 m:null="true" />
        <d:YR_QualificationPublicationAuthor2 m:null="true" />
        <d:YR_QualificationPublicationAuthor3 m:null="true" />
        <d:YR_QualificationPublicationNumberOfAuthors>0</d:YR_QualificationPublicationNumberOfAuthors>
        <d:YR_QualificationPublicationFirstAuthor>false</d:YR_QualificationPublicationFirstAuthor>
        <d:YR_QualificationPublicationTitle m:null="true" />
        <d:YR_QualificationPublicationJournal m:null="true" />
        <d:YR_QualificationPublicationVolume m:null="true" />
        <d:YR_QualificationPublicationIssue m:null="true" />
        <d:YR_QualificationPublicationPages m:null="true" />
        <d:YR_QualificationPublicationKeywords m:null="true" />
        <d:YR_QualificationPublicationURL m:null="true" />
        <d:YR_QualificationPublicationDOI m:null="true" />
        <d:YR_QualificationResearchExperiencePosition m:null="true" />
        <d:YR_QualificationResearchExperienceDescription m:null="true" />
        <d:YR_QualificationAwardName m:null="true" />
        <d:YR_QualificationAwardDescription m:null="true" />
        <d:YR_QualificationConferencePresentationType m:null="true" />
        <d:YR_QualificationConferencePresentationTitle m:null="true" />
        <d:YR_QualificationConferencePresentationDescription m:null="true" />
        <d:YR_QualificationTutoringExperienceSubject m:null="true" />
        <d:YR_QualificationTutoringExperienceDescription m:null="true" />
        <d:YR_QualificationTutoringExperienceEngagement m:null="true" />
        <d:YR_QualificationTutoringExperienceExtent m:null="true" />
        <d:YR_QualificationLanguage m:null="true" />
        <d:YR_QualificationLanguageListeningLevel m:null="true" />
        <d:YR_QualificationLanguageSpeakingLevel m:null="true" />
        <d:YR_QualificationInstitutionName m:null="true" />
        <d:YR_QualificationInstitutionCity m:null="true" />
        <d:YR_QualificationInstitutionCountry m:null="true" />
        <d:YR_QualificationInstitutionWebsite m:null="true" />
      </m:properties>
    </content>
  </entry>
};

declare %private function _:co-template($uuid){
  <data>
  {for $i in 1 to 15
  let $guid := random:uuid()
  return

  <entry xmlns="http://www.w3.org/2005/Atom" xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices" xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata">
    <id>{$C:ODATA-URL}ContactOptions(guid'{$guid}')</id>
    <title type="text"/>
    <updated>2012-07-05T11:21:34Z</updated>
    <author>
      <name/>
    </author>
    <link rel="edit" title="ContactOptions" href="ContactOptions(guid'{$guid}')"/>
    <link rel="http://schemas.microsoft.com/ado/2007/08/dataservices/related/YoungResearcher" type="application/atom+xml;type=entry" title="YoungResearcher" href="ContactOptions(guid'{$guid}')/YoungResearcher"/>
    <category term="LindauNobelCRMModel.ContactOptions" scheme="http://schemas.microsoft.com/ado/2007/08/dataservices/scheme"/>
    <content type="application/xml">
      <m:properties>
        <d:ID m:type="Edm.Guid">{$guid}</d:ID>
        <d:ID_Person m:type="Edm.Guid">{$uuid}</d:ID_Person>
        <d:YR_ContactOption>Twitter/Facebook/LinkedIN/[…] {$i}</d:YR_ContactOption>
        <d:YR_ContactOptionDetail>Screenname {$i}</d:YR_ContactOptionDetail>
      </m:properties>
    </content>
  </entry>}
  </data>
};
