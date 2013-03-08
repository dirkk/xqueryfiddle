module namespace _ = "http://napers.lindau-nobel.org/tmpl";

declare namespace xf = "http://www.w3.org/2002/xforms";
declare namespace ev = "http://www.w3.org/2001/xml-events";

import module namespace C = 'http://lindau-nobel.org/constants';
import module namespace ex = "http://lindau-nobel.org/exchange";
import module namespace util  = "http://napers.lindau-nobel.org/util";

(:~
: Utility function to wrap content with required XForms boilerplate.
: This method can easily be changed to suit your needs.
: @param $content a map containing entries for title, model and form
:)
declare function _:wrap-xforms($content as item()){
  <html xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xf="http://www.w3.org/2002/xforms"
  xmlns:ev="http://www.w3.org/2001/xml-events"
  xmlns:m="http://schemas.microsoft.com/ado/2007/08/dataservices/metadata"
  xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices"
  >
     <head>
      <link href="/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
      <link href="/static/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" />
      <link href="/static/bootstrap/css/fileuploader.min.css" rel="stylesheet" />
      <link href="/static/style.css?v=1" rel="stylesheet" />
      <!--[if IE]>
        <link rel="stylesheet" type="text/css" href="/static/style_ie.css" />
      <![endif]-->
      <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js"></script>  
      <script src="/static/controller.js"></script>

      <meta name="viewport" content="width=device-width, initial-scale=1.0" />

      <title>{ $content("title") }</title>
      <xf:model xmlns="">
        { $content("model") }
      </xf:model>
    </head>
    <body>
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
        &#160;
        </div>
      </div>
    </div>

      <div class="container">
      <div class="row" style="padding:1em 0 1em 0;">
      <div class="span12">
        <img src="/static/bootstrap/img/lindau_logo_top_beta.png" />
      </div></div>

          <div class="row">
          <div class="span12" id="main">
          {$content("body")}
        </div>

          </div>
        <hr />

        <footer style='text-align:right;'>
          <p>
            {util:get-infotext('T0029')}
          </p>
        </footer>

      </div><!--/.fluid-container-->

      <br />
      <!-- Placed at the end of the document so the pages load faster -->
      <script type="text/javascript" src="/static/bootstrap/js/jquery.171.min.js"></script>
      <script type="text/javascript" src="/static/bootstrap/js/bootstrap.min.js"></script>
      <script type="text/javascript" src="/static/bootstrap/js/fileuploader.min.js"></script>
      <script type="text/javascript" src="/static/my.js"></script>
      <script>
      var userfolder = "{$content("userfolder")}";
      var targetname = "{$content("targetname")}";
      <![CDATA[

  		// DOM-ready event is a much option here, just using onload in demo for simplicity
  		// jQuery users can use $(function()) { ...

        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-33201299-1']);
        _gaq.push(['_setDomainName', 'lindau-nobel.org']);
        _gaq.push(['_addIgnoredRef', 'lindau-nobel.org']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();


  		]]>

      </script>
  <script>
  <![CDATA[
    dojo.subscribe("/xf/ready", function(){
          fluxProcessor.unloadMsg = "You have unsaved changes.";
            });
     ]]>
 </script>

     </body>

  </html>

};

declare function _:wrap-xforms-multiple($content as item()){
  <html ng-app="">
     <head>
      <link href="/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
      <link href="/static/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" />
      <link href="/static/bootstrap/css/fileuploader.min.css" rel="stylesheet" />
      <link href="/static/style.css?v=1" rel="stylesheet" />
      <!--[if IE]>
        <link rel="stylesheet" type="text/css" href="/static/style_ie.css" />
      <![endif]-->
      <script type="text/javascript" src="/static/bootstrap/js/jquery.171.min.js"></script>
      <script type="text/javascript" src="/static/bootstrap/js/bootstrap.min.js"></script>
      <script type="text/javascript" src="/static/bootstrap-datepicker.js"></script>
      <script type="text/javascript" src="/static/bootstrap/js/fileuploader.min.js"></script>
      <script type="text/javascript" src="/static/my.js"></script>
      <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js"></script>  
      <script src="/static/controller.js"></script>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />

      <title>{ $content("title") }</title>
</head>
    <body>
      { $content("model") }
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
        &#160;
        </div>
      </div>
    </div>

      <div class="container">
      <div class="row" style="padding:1em 0 1em 0;">
      <div class="span12">
        <img src="/static/bootstrap/img/lindau_logo_top_beta.png" />
      </div></div>

          <div class="row">
          <div class="span12" id="main">
          {$content("body")}
        </div>

          </div>
        <hr />

        <footer style='text-align:right;'>
          <p>
            {util:get-infotext('T0029')}
          </p>
        </footer>

      </div>

      <br />
      <span>
      <script>
      window.onload = setTooltips();
      var userfolder = "{$content("userfolder")}";
      var targetname = "{$content("targetname")}";
      <![CDATA[

  		// DOM-ready event is a much option here, just using onload in demo for simplicity
  		// jQuery users can use $(function()) { ...

        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-33201299-1']);
        _gaq.push(['_setDomainName', 'lindau-nobel.org']);
        _gaq.push(['_addIgnoredRef', 'lindau-nobel.org']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();


  		]]>

      </script>
      </span>

     </body>

  </html>

};

(:~
: Utility function to wrap content with required XForms boilerplate.
: This method can easily be changed to suit your needs.
: @param $content a map containing entries for title, model and form
:)
declare function _:wrap($content as item()){
  <html xmlns="http://www.w3.org/1999/xhtml" ng-app="">
    <head>
      <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
      <meta charset="utf-8" />
      <title>{$content("title")}</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta name="description" content="" />
      <meta name="author" content="" />

      <link href="/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
      <link href="/static/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" />
      <link href="/static/style.css?v=1" rel="stylesheet" />
      <!--[if IE]>
        <link rel="stylesheet" type="text/css" href="/static/style_ie.css" />
      <![endif]-->
      <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js"></script>  
      <script src="/static/controller.js"></script>

<!--      <script type="text/javascript" src="/static/instantx.js"></script>-->

      <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
      <!--[if lt IE 9]>
        <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
      <![endif]-->

      <!-- Le fav and touch icons
      <link rel="shortcut icon" href="/static/bootstrap/ico/favicon.ico" />
      <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/static/bootstrap/ico/apple-touch-icon-144-precomposed.png" />
      <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/static/bootstrap/ico/apple-touch-icon-114-precomposed.png" />
      <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/static/bootstrap/ico/apple-touch-icon-72-precomposed.png" />
      <link rel="apple-touch-icon-precomposed" href="/static/bootstrap/ico/apple-touch-icon-57-precomposed.png" />-->
    </head>

    <body>
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          &#160;
        </div>
      </div>
    </div>

      <div class="container">
      <div class="row" style="padding:1em 0 1em 0;">
      <div class="span12">
        <img src="/static/bootstrap/img/lindau_logo_top_beta.png" />
      </div></div>

          <div class="row">
          <div class="span12" id="main">
      { $content("body") }
      </div></div>
      <hr/>

      <footer style='text-align:right;'>
        <p>
          {util:get-infotext('T0029')}
        </p>
      </footer>

      </div><!--/.fluid-container-->

      <!-- Le javascript
      ================================================== -->
      <!-- Placed at the end of the document so the pages load faster -->
      <script type="text/javascript" src="/static/bootstrap/js/jquery.171.min.js"></script>
      <script type="text/javascript" src="/static/bootstrap/js/bootstrap.min.js"></script>
      {
        $content("scripts") !
        <script type="text/javascript" src="/static/bootstrap/js/{.}.js"></script>
      }
      <script type="text/javascript" src="/static/my.js"></script>

      <script type="text/javascript">
      <![CDATA[

       var $buoop = {};
      $buoop.ol = window.onload;
      window.onload=function(){
       try {if ($buoop.ol) $buoop.ol();}catch (e) {}
       var e = document.createElement("script");
       e.setAttribute("type", "text/javascript");
       e.setAttribute("src", "http://browser-update.org/update.js");
       document.body.appendChild(e);
      };

        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-33201299-1']);
        _gaq.push(['_setDomainName', 'lindau-nobel.org']);
        _gaq.push(['_addIgnoredRef', 'lindau-nobel.org']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
       ]]>
      </script>
    </body>
  </html>

};

(:~
: Utility function to wrap content with required XForms boilerplate.
: This method can easily be changed to suit your needs.
: @param $content a map containing entries for title, model and form
:)
declare function _:wrap-solo($content as item()){
  <html lang="en">
    <head>
      <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
      <meta charset="utf-8" />
      <title>{$content("title")}</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta name="description" content="" />
      <meta name="author" content="" />

      <link href="/static/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
      <link href="/static/bootstrap/css/bootstrap-responsive.min.css" rel="stylesheet" />
      <link href="/static/style.css?v=1" rel="stylesheet" />
      <!--[if IE]>
        <link rel="stylesheet" type="text/css" href="/static/style_ie.css" />
      <![endif]-->
      <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js"></script>  
      <script src="/static/controller.js"></script>

<!--      <script type="text/javascript" src="/static/instantx.js"></script>-->

      <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
      <!--[if lt IE 9]>
        <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
      <![endif]-->

      <!-- Le fav and touch icons
      <link rel="shortcut icon" href="/static/bootstrap/ico/favicon.ico" />
      <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/static/bootstrap/ico/apple-touch-icon-144-precomposed.png" />
      <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/static/bootstrap/ico/apple-touch-icon-114-precomposed.png" />
      <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/static/bootstrap/ico/apple-touch-icon-72-precomposed.png" />
      <link rel="apple-touch-icon-precomposed" href="/static/bootstrap/ico/apple-touch-icon-57-precomposed.png" />-->
    </head>
    <body>
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
        &#160;
        </div>
      </div>
    </div>

      <div class="container">
      <div class="row" style="padding:1em 0 1em 0;">
      <div class="span12">
        <img src="/static/bootstrap/img/lindau_logo_top_beta.png" />
      </div></div>
      <div class="row">
      <div class="span12" id="main">
      { $content("body") }
      </div></div>
      <hr/>

      <footer style='text-align:right;'>
        <p>
          {util:get-infotext('T0029')}
        </p>
      </footer>

      </div><!--/.fluid-container-->

      <!-- Le javascript
      ================================================== -->
      <!-- Placed at the end of the document so the pages load faster -->
      <!-- visualsearch integration -->
      <script type="text/javascript" src="/static/bootstrap/js/jquery.171.min.js"></script>
      <script type="text/javascript" src="/static/bootstrap/js/bootstrap.min.js"></script>
      <!-- jquery ui -->
      <script type="text/javascript" src="/static/bootstrap/js/nobel-search.min.js"></script>
      <script type="text/javascript" src="/static/my.js"></script>

      <script type="text/javascript">
      <![CDATA[

      var $buoop = {}
      $buoop.ol = window.onload;
      window.onload=function(){
       try {if ($buoop.ol) $buoop.ol();}catch (e) {}
       var e = document.createElement("script");
       e.setAttribute("type", "text/javascript");
       e.setAttribute("src", "http://browser-update.org/update.js");
       document.body.appendChild(e);
      }
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-33201299-1']);
      _gaq.push(['_setDomainName', 'lindau-nobel.org']);
      _gaq.push(['_addIgnoredRef', 'lindau-nobel.org']);
      _gaq.push(['_trackPageview']);

      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();



       ]]>
      </script>
  <script>
  <![CDATA[
    dojo.subscribe("/xf/ready", function(){
          fluxProcessor.unloadMsg = "You have unsaved changes.";
            });
     ]]>
 </script>

    </body>
  </html>
};


declare
%private
function _:get-portrait($url) {
  try {
    if ($url != '') then
      <img class="img-polaroid portrait " src="{$C:BASE-URL}/{$url}" />
    else
      <img src="/105x135.gif" class="img-polaroid portrait "  />
  } catch * {
    <img src="/105x135.gif" class="portrait img-polaroid " />
  }
};

declare
%private
function _:get-name($person) {
  let $a := $person//*:P_NameFirst
  let $b := $person//*:P_NameMiddle
  let $c := $person//*:P_NameLastPre
  let $d := $person//*:P_NameLast
  return string(concat($a || ' ', if($b and $b/text() != '') then $b || ' ' else (), if($c and $c/text() != '') then $c || ' ' else (), $d))
};

declare
%private
function _:get-namer($person) {
  let $c := $person//*:P_NameFirst
  let $d := $person//*:P_NameMiddle
  let $b := $person//*:P_NameLastPre
  let $a := $person//*:P_NameLast
  return string(concat($a || ' ', if($b and $b/text() != '') then ($b||",") || ' ' else (), if($c and $c/text() != '') then $c || ' ' else (), $d))
};

(: Computes the age of a participant (more or less) :)
declare function _:compute-age($birthday as xs:dateTime) {
  ((current-date() - xs:date($birthday)) div xs:dayTimeDuration('P1D') idiv 365.242199)
};
