(:~
 : Global constants.
 :
 : (C) 2012, Nobelstiftung
 : by Alexander Holupirek (BaseX GmbH)
 :)
module namespace _ = 'http://lindau-nobel.org/constants';

declare variable $_:ODATA-URL := "http://exchange.lindau-nobel.de:8082/LindauNobelCRMServicesDEV/WcfDataService1.svc/";
(: People database. :)
declare variable $_:DB := db:open('Persons');

(: WebAccounts database:)
declare variable $_:ACCOUNTS := db:open('WebAccounts');
declare variable $_:ACCOUNTS-URL := $_:ODATA-URL || "WebAccounts(guid'__GUID__')";
declare variable $_:ACCOUNTS-RAW-URL := $_:ODATA-URL || "WebAccounts";

(: Open Applications :)
declare variable $_:OPEN-APPLICATIONS-RAW-URL := $_:ODATA-URL || "OpenApplications";
declare variable $_:OPEN-APPLICATIONS-URL := $_:ODATA-URL || "OpenApplications(guid'__GUID__')";

(: Persons database. :)
declare variable $_:PERSONS := db:open('Persons');
declare variable $_:PERSONS-URL := $_:ODATA-URL || "Persons(guid'__GUID__')";
declare variable $_:PERSONS-RAW-URL := $_:ODATA-URL || "Persons";

(: Meetings :)
declare variable $_:MEETINGS-URL:= $_:ODATA-URL || "Meetings(guid'__GUID__')";
declare variable $_:MEETINGS-RAW-URL := $_:ODATA-URL || "Meetings";

(: Reviews :)
declare variable $_:REVIEWS-URL:= $_:ODATA-URL || "Reviews(guid'__GUID__')";
declare variable $_:REVIEWS-RAW-URL := $_:ODATA-URL || "Reviews";

(: YoungResearchers :)
declare variable $_:YOUNGRESEARCHER-URL:= $_:ODATA-URL || "Persons(guid'__GUID__')";
declare variable $_:YOUNGRESEARCHER-RAW-URL := $_:ODATA-URL || "Persons";

(: Nominations table :)
declare variable $_:NOMINATIONS-URL := $_:ODATA-URL || "Nominations(guid'__GUID__')";
declare variable $_:NOMINATIONS-RAW-URL := $_:ODATA-URL || "Nominations";

(: Nominations Support table :)
declare variable $_:NOMINATIONS-SUPPORT-URL := $_:ODATA-URL || "NominationSupportHistory(guid'__GUID__')";
declare variable $_:NOMINATIONS-SUPPORT-RAW-URL := $_:ODATA-URL || "NominationSupportHistory";

(: Meeting table :)
declare variable $_:MEETING-URL := $_:ODATA-URL || "Meetings(guid'__GUID__')";
declare variable $_:MEETING-RAW-URL := $_:ODATA-URL || "Meetings";

(: Meeting Participation table :)
declare variable $_:MEETING-PARTICIPATION-URL := $_:ODATA-URL || "MeetingParticipation(guid'__GUID__')";
declare variable $_:MEETING-PARTICIPATION-RAW-URL := $_:ODATA-URL || "MeetingParticipation";

(: Qualifications table :)
declare variable $_:QUALIFICATIONS-URL := $_:ODATA-URL || "Qualifications(guid'__GUID__')";
declare variable $_:QUALIFICATIONS-RAW-URL := $_:ODATA-URL || "Qualifications";

(: Companies database. :)
declare variable $_:COMPANIES := db:open('Companies');
declare variable $_:COMPANIES-RAW-URL := $_:ODATA-URL || "Companies";
declare variable $_:COMPANIES-URL := $_:ODATA-URL || "Companies(guid'__GUID__')";

(: Contact Options table :)
declare variable $_:CONTACT-OPTIONS-URL := $_:ODATA-URL || "ContactOptions(guid'__GUID__')";
declare variable $_:CONTACT-OPTIONS-RAW-URL := $_:ODATA-URL || "ContactOptions";

(: Countries database. :)
declare variable $_:COUNTRIES-URL := $_:ODATA-URL || "NAPERSCountries";

(: Documents uploaded by the user :)
declare variable $_:DOCUMENTS-USER-RAW-URL := $_:ODATA-URL || "DocumentsUser";
declare variable $_:DOCUMENTS-USER-URL := $_:ODATA-URL || "DocumentsUser(guid'__GUID__')";

(: Reviews Average:)
declare variable $_:RESULTS-FINAL-REVIEW-RAW-URL := $_:ODATA-URL || "ReviewResultsAverageFinal";
declare variable $_:RESULTS-FINAL-REVIEW-URL := $_:ODATA-URL || "ReviewResultsAverageFinal(guid'__GUID__')";

(: Reviews Average Pre :)
declare variable $_:RESULTS-PRE-REVIEW-RAW-URL := $_:ODATA-URL || "ReviewResultsAveragePre";
declare variable $_:RESULTS-PRE-REVIEW-URL := $_:ODATA-URL || "ReviewResultsAveragePre(guid'__GUID__')";

(: NAPERS system table :)
declare variable $_:NAPERS-SYSTEM-RAW-URL := $_:ODATA-URL || "NAPERS";

(: Nobel title. :)
declare variable $_:NOBEL := 'The Lindau Nobel Laureate Meetings';

(: Starting page. :)
(: Used to return to for not-logged in users. :)
declare variable $_:START-PAGE := "/";

(: HTTP base URL :)
declare variable $_:BASE-URL := "http://lindau-repository.org:9876/";

(: Fake date. :)
declare variable $_:FAKEDATETIME := xs:dateTime('1212-12-12T12:12:12');

(: Login in ist: no-reply@lindau-nobel.de und PW:  Muck1fago :)
declare variable $_:email := <email 
  from="The Lindau Nobel Laureate Meetings &lt;no-reply@lindau-repository.org&gt;"
  user="no-reply@lindau-repository.org"
  host="smtprelaypool.ispgateway.de"
  port="465"
  ssl="true"
  password="tzu84#77x"/>;

 (: static country codes :)
 declare variable $_:CC := map{ "MT":="Malta","ZW":="Zimbabwe","CK":="Cook Islands","IQ":="Iraq","FI":="Finland","LT":="Lithuania","TO":="Tonga","SC":="Seychelles","YT":="Mayotte","PR":="Puerto Rico","BQ":="Bonaire, Sint Eustatius and Saba","PY":="Paraguay","CZ":="Czech Republic","MC":="Monaco","SV":="El Salvador","KZ":="Kazakhstan","NU":="Niue","AZ":="Azerbaijan","ML":="Mali","JE":="Jersey","MU":="Mauritius","BI":="Burundi","MR":="Mauritania","KG":="Kyrgyzstan","EE":="Estonia","HN":="Honduras","KP":="North Korea","TL":="Timor-Leste","SN":="Senegal","BH":="Bahrain","CF":="Central African Republic","KW":="Kuwait","SG":="Singapore","SI":="Slovenia","VE":="Venezuela","TH":="Thailand","NG":="Nigeria","JM":="Jamaica","PW":="Palau","GR":="Greece","AT":="Austria","TD":="Chad","TM":="Turkmenistan","KN":="Saint Kitts and Nevis","WS":="Samoa","CX":="Christmas Island","RS":="Serbia","ST":="Sao Tome and Principe","RE":="Réunion","UM":="United States Minor Outlying Islands","GW":="Guinea-Bissau","SL":="Sierra Leone","CO":="Colombia","GU":="Guam","DJ":="Djibouti","DZ":="Algeria","LC":="Saint Lucia","PA":="Panama","YE":="Yemen","UA":="Ukraine","NE":="Niger","CI":="Côte d'Ivoire","DM":="Dominica","CR":="Costa Rica","BR":="Brazil","GT":="Guatemala","PN":="Pitcairn","BS":="Bahamas","SH":="Saint Helena, Ascension and Tristan da Cunha","IE":="Ireland","MH":="Marshall Islands","FO":="Faroe Islands","HR":="Croatia","SS":="South Sudan","GE":="Georgia","JO":="Jordan","SZ":="Swaziland","KH":="Cambodia","PE":="Peru","GA":="Gabon","LB":="Lebanon","ES":="Spain","GG":="Guernsey","AE":="United Arab Emirates","TW":="Taiwan, Province of China","BT":="Bhutan","CC":="Cocos (Keeling) Islands","GH":="Ghana","KI":="Kiribati","TG":="Togo","LU":="Luxembourg","AW":="Aruba","GY":="Guyana","PK":="Pakistan","IR":="Iran","TC":="Turks and Caicos Islands","RW":="Rwanda","LS":="Lesotho","MF":="Saint Martin (French part)","SM":="San Marino","SY":="Syrian Arab Republic","GD":="Grenada","GI":="Gibraltar","MQ":="Martinique","NR":="Nauru","RU":="Russian Federation","PM":="Saint Pierre and Miquelon","JP":="Japan","DO":="Dominican Republic","NP":="Nepal","BF":="Burkina Faso","SO":="Somalia","PG":="Papua New Guinea","MG":="Madagascar","FK":="Falkland Islands (Malvinas)","AG":="Antigua and Barbuda","SX":="Sint Maarten (Dutch part)","LR":="Liberia","BG":="Bulgaria","TJ":="Tajikistan","HK":="Hong Kong","BO":="Bolivia","RO":="Romania","VI":="Virgin Islands, U.S.","KR":="South Korea","CN":="China","AX":="Åland Islands","BL":="Saint Barthélemy","SB":="Solomon Islands","BB":="Barbados","CH":="Switzerland","ME":="Montenegro","MZ":="Mozambique","EC":="Ecuador","MD":="Moldova","GL":="Greenland","TK":="Tokelau","PT":="Portugal","TR":="Turkey","SJ":="Svalbard and Jan Mayen","SK":="Slovakia","NO":="Norway","UG":="Uganda","ID":="Indonesia","BV":="Bouvet Island","NF":="Norfolk Island","PH":="Philippines","MP":="Northern Mariana Islands","BJ":="Benin","MK":="Macedonia","CV":="Cape Verde","BY":="Belarus","NC":="New Caledonia","GF":="French Guiana","EH":="Western Sahara","BW":="Botswana","SR":="Suriname","ZM":="Zambia","GM":="Gambia","MM":="Myanmar","US":="United States","NA":="Namibia","LI":="Liechtenstein","ER":="Eritrea","CY":="Cyprus","MN":="Mongolia","LK":="Sri Lanka","AR":="Argentina","BM":="Bermuda","CW":="Curaçao","QA":="Qatar","IO":="British Indian Ocean Territory","PF":="French Polynesia","EG":="Egypt","SA":="Saudi Arabia","PL":="Poland","MA":="Morocco","GQ":="Equatorial Guinea","NZ":="New Zealand","AF":="Afghanistan","GP":="Guadeloupe","KY":="Cayman Islands","DK":="Denmark","UZ":="Uzbekistan","MV":="Maldives","IT":="Italy","KE":="Kenya","TZ":="Tanzania","FR":="France","VA":="Holy See (Vatican City State)","IL":="Israel","CA":="Canada","TV":="Tuvalu","VN":="Viet Nam","GB":="United Kingdom","MX":="Mexico","TF":="French Southern Territories","MO":="Macao","PS":="Palestinian Territory","BN":="Brunei Darussalam","VU":="Vanuatu","KM":="Comoros","NL":="Netherlands","ET":="Ethiopia","OM":="Oman","SE":="Sweden","LY":="Libya","LV":="Latvia","CU":="Cuba","MY":="Malaysia","VG":="Virgin Islands, British","DE":="Germany","WF":="Wallis and Futuna","AQ":="Antarctica","HU":="Hungary","FM":="Micronesia","ZA":="South Africa","CM":="Cameroon","AD":="Andorra","BA":="Bosnia and Herzegovina","BE":="Belgium","AU":="Australia","MS":="Montserrat","BD":="Bangladesh","GN":="Guinea","TN":="Tunisia","CL":="Chile","HM":="Heard Island and McDonald Islands","AO":="Angola","IN":="India","AI":="Anguilla","IS":="Iceland","HT":="Haiti","MW":="Malawi","FJ":="Fiji","BZ":="Belize","CG":="Congo","IM":="Isle of Man","AL":="Albania","VC":="Saint Vincent and the Grenadines","NI":="Nicaragua","TT":="Trinidad and Tobago","GS":="South Georgia and the South Sandwich Islands","SD":="Sudan","AS":="American Samoa","UY":="Uruguay","AM":="Armenia","LA":="Laos" };
