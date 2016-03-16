<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on
	Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
	or libraries that are released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with
	independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without
	Mura CMS under the license of your choice, provided that you follow these specific guidelines:

	Your custom code

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories.

	 /admin/
	 /tasks/
	 /config/
	 /requirements/mura/
	 /Application.cfc
	 /index.cfm
	 /MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work
	under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL
	requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your
	modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfsilent><cfparam name="request.action" default="core:cplugin.plugin">
<cfparam name="rc.originalfuseaction" default="#listLast(listLast(request.action,":"),".")#">
<cfparam name="rc.originalcircuit"  default="#listFirst(listLast(request.action,":"),".")#">
<cfparam name="rc.jsLib" default="jquery">
<cfparam name="rc.jsLibLoaded" default="false">
<cfparam name="rc.activetab" default="0">
<cfparam name="rc.activepanel" default="0">
<cfparam name="rc.siteid" default="#session.siteID#"><cfoutput></cfoutput>
<cfparam name="rc.frontEndProxyLoc" default="">
<cfparam name="session.frontEndProxyLoc" default="#rc.frontEndProxyLoc#">
<cfparam name="rc.sourceFrame" default="modal">

<cfif len(rc.frontEndProxyLoc)>
	<cfset session.frontEndProxyLoc=rc.frontEndProxyLoc>
</cfif>
</cfsilent><cfoutput><cfprocessingdirective suppressWhitespace="true"><!DOCTYPE html>
<cfif cgi.http_user_agent contains 'msie'>
	<!--[if lt IE 7 ]><html class="mura ie ie6" lang="#esapiEncode('html_attr',session.locale)#"><![endif]-->
	<!--[if IE 7 ]><html class="mura ie ie7" lang="#esapiEncode('html_attr',session.locale)#"><![endif]-->
	<!--[if IE 8 ]><html class="mura ie ie8" lang="#esapiEncode('html_attr',session.locale)#"><![endif]-->
	<!--[if (gte IE 9)|!(IE)]><!--><html lang="#esapiEncode('html_attr',session.locale)#" class="mura ie"><!--<![endif]-->
<cfelse>
<!--[if IE 9]> <html lang="en_US" class="ie9 mura no-focus"> <![endif]-->
<!--[if gt IE 9]><!--> <html lang="#esapiEncode('html_attr',session.locale)#" class="mura no-focus"><!--<![endif]-->
</cfif>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<title>#esapiEncode('html', application.configBean.getTitle())#</title>
    	<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1.0">
		<meta name="author" content="Blue River Interactive Group">
		<meta name="robots" content="noindex, nofollow, noarchive">
		<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate">

		<cfif Len(application.configBean.getWindowDocumentDomain())>
			<script type="text/javascript">
				window.document.domain = '#application.configBean.getWindowDocumentDomain()#';
			</script>
		</cfif>

		<cfif cgi.http_user_agent contains 'msie'>
			<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
			<!--[if lt IE 9]>
			   <script src="#application.configBean.getContext()#/admin/assets/js/html5.js"></script>
			<![endif]-->
		</cfif>

		<link rel="shortcut icon" href="#application.configBean.getContext()#/admin/assets/ico/favicon.ico" type="image/x-icon" />

<!--- TODO GoWest : PNGs / icons : 2015-12-02T13:59:23-07:00 --->

      <link rel="icon" type="image/png" href="assets/img/favicons/favicon-16x16.png" sizes="16x16">
      <link rel="icon" type="image/png" href="assets/img/favicons/favicon-32x32.png" sizes="32x32">
      <link rel="icon" type="image/png" href="assets/img/favicons/favicon-96x96.png" sizes="96x96">
      <link rel="icon" type="image/png" href="assets/img/favicons/favicon-160x160.png" sizes="160x160">
      <link rel="icon" type="image/png" href="assets/img/favicons/favicon-192x192.png" sizes="192x192">

      <link rel="apple-touch-icon" sizes="57x57" href="assets/img/favicons/apple-touch-icon-57x57.png">
      <link rel="apple-touch-icon" sizes="60x60" href="assets/img/favicons/apple-touch-icon-60x60.png">
      <link rel="apple-touch-icon" sizes="72x72" href="assets/img/favicons/apple-touch-icon-72x72.png">
      <link rel="apple-touch-icon" sizes="76x76" href="assets/img/favicons/apple-touch-icon-76x76.png">
      <link rel="apple-touch-icon" sizes="114x114" href="assets/img/favicons/apple-touch-icon-114x114.png">
      <link rel="apple-touch-icon" sizes="120x120" href="assets/img/favicons/apple-touch-icon-120x120.png">
      <link rel="apple-touch-icon" sizes="144x144" href="assets/img/favicons/apple-touch-icon-144x144.png">
      <link rel="apple-touch-icon" sizes="152x152" href="assets/img/favicons/apple-touch-icon-152x152.png">
      <link rel="apple-touch-icon" sizes="180x180" href="assets/img/favicons/apple-touch-icon-180x180.png">

<!--- TODO GoWest :  keep spinner? : 2015-12-02T14:11:23-07:00 --->
		 <!-- Spinner JS -->
		<script src="#application.configBean.getContext()#/admin/assets/js/spin.min.js" type="text/javascript"></script>

			<!--- TODO GoWest : include full theme core js in compact view? : 2016-01-29T16:49:50-07:00 --->
	    <!-- OneUI Core JS: jQuery, Bootstrap, slimScroll, scrollLock, Appear, CountTo, Placeholder, Cookie and App.js -->
   		<script src="#application.configBean.getContext()#/admin/assets/js/oneui.min.js"></script>

<!--- TODO GoWest : keep both spin.js? : see above 2015-12-02T14:12:47-07:00 --->
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.spin.js" type="text/javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery.collapsibleCheckboxTree.js?coreversion=#application.coreversion#" type="text/javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-ui.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-ui-i18n.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

    <!-- Web fonts -->
    <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400italic,600,700%7COpen+Sans:300,400,400italic,600,700">

		<!-- Mura Admin JS -->
		<script src="#application.configBean.getContext()#/admin/assets/js/admin.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

		<!-- CK Editor/Finder -->
		<script type="text/javascript" src="#application.configBean.getContext()#/requirements/ckeditor/ckeditor.js"></script>
		<script type="text/javascript" src="#application.configBean.getContext()#/requirements/ckeditor/adapters/jquery.js"></script>
		<script type="text/javascript" src="#application.configBean.getContext()#/requirements/ckfinder/ckfinder.js"></script>

		<!-- Color Picker -->
		<script type="text/javascript" src="#application.configBean.getContext()#/requirements/colorpicker/js/bootstrap-colorpicker.js?coreversion=#application.coreversion#"></script>
		<link href="#application.configBean.getContext()#/requirements/colorpicker/css/colorpicker.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />

		<!-- JSON -->
		<script src="#application.configBean.getContext()#/admin/assets/js/json2.js" type="text/javascript"></script>

		<!-- Utilities to support iframe communication -->
		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-resize.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/porthole/porthole.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>
		<script src="#application.configBean.getContext()#/admin/assets/js/chart.min.js?coreversion=#application.coreversion#" type="text/javascript"></script>

		<script type="text/javascript">
		var htmlEditorType='#application.configBean.getValue("htmlEditorType")#';
		var context='#application.configBean.getContext()#';
		var themepath='#application.settingsManager.getSite(rc.siteID).getThemeAssetPath()#';
		var rb='#lcase(esapiEncode('javascript',session.rb))#';
		var siteid='#esapiEncode('javascript',session.siteid)#';
		var activepanel=#esapiEncode('javascript',rc.activepanel)#;
		var activetab=#esapiEncode('javascript',rc.activetab)#;
		var webroot='#esapiEncode('javascript',left($.globalConfig("webroot"),len($.globalConfig("webroot"))-len($.globalConfig("context"))))#';
		var fileDelim='#esapiEncode('javascript',$.globalConfig("fileDelim"))#';
		</script>

		<link href="#application.configBean.getContext()#/admin/assets/css/admin.min.css" rel="stylesheet" type="text/css" />
		#session.dateKey#
		<script type="text/javascript">
			var frontEndProxy;
			jQuery(document).ready(function(){

 			// tab drop
 			$('.mura-tabs').tabdrop({text: '<i class="mi-chevron-down"></i>'});

				if (top.location != self.location) {

					function getHeight(){
						if(document.all){
							return Math.max(document.body.scrollHeight, document.body.offsetHeight);
						} else {
							return Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight);
						}
					}

					frontEndProxy = new Porthole.WindowProxy("#esapiEncode('javascript',session.frontEndProxyLoc)##application.configBean.getContext()#/admin/assets/js/porthole/proxy.html");
					frontEndProxy.post({cmd:
											'setHeight',
											height:getHeight(),
											'targetFrame': '#esapiEncode("javascript",rc.sourceFrame)#'
										});
					jQuery(this).resize(function(e){
						frontEndProxy.post({cmd:
											'setHeight',
											height:getHeight(),
											'targetFrame': '#esapiEncode("javascript",rc.sourceFrame)#'
										});
					});
				};


			});
		</script>
		#rc.ajax#

		<cfif cgi.http_user_agent contains 'msie'>
			<!--[if lte IE 8]>
			<link href="#application.configBean.getContext()#/admin/assets/css/ie.min.css?coreversion=#application.coreversion#" rel="stylesheet" type="text/css" />
			<![endif]-->

			<!--[if lte IE 7]>
			<script src="#application.configBean.getContext()#/admin/assets/js/upgrade-notification.min.js" type="text/javascript"></script>
			<![endif]-->
		</cfif>
	</head>
	<body id="#esapiEncode('html_attr',rc.originalcircuit)#" class="compact <cfif rc.sourceFrame eq 'modal'>modal-wrapper<cfelse>configurator-wrapper</cfif>">
		<div id="mura-content">
		<cfif rc.sourceFrame eq 'modal'>
			<a id="frontEndToolsModalClose" href="javascript:frontEndProxy.post({cmd:'close'});"><i class="mi-times-circle"></i></a>
			<cfinclude template="includes/dialog.cfm">
		</cfif>

			<div class="main mura-layout-row"></cfprocessingdirective>#body#<cfprocessingdirective suppressWhitespace="true"></div>

		</div> <!-- /mura-content -->

		<script src="#application.configBean.getContext()#/admin/assets/js/jquery/jquery-tagselector.js?coreversion=#application.coreversion#"></script>

		<script src="#application.configBean.getContext()#/admin/assets/js/bootstrap-tabdrop.js"></script>

	</body>
</html></cfprocessingdirective>
</cfoutput>
