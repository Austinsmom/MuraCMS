<cfsilent>
<cfset rsPluginScripts=application.pluginManager.getScripts("onLinkSelect",session.siteID)>
<cfscript>
if (NOT IsDefined("attributes"))
    attributes=structNew();
StructAppend(attributes, url, "no");
StructAppend(attributes, form, "no");
</cfscript>
</cfsilent>
<cfif not rsPluginScripts.recordcount>
<cfsilent>
<cfparam name="attributes.startrow" default="1">
<cfparam name="attributes.keywords" default="">
<cfparam name="attributes.siteid" default="#session.siteid#">
<cfset request.rsList=application.contentManager.getPrivateSearch('#attributes.siteid#','#attributes.keywords#')/>
<cfset request.nextn=application.utility.getNextN(request.rsList,30,attributes.startrow) />
<cfset request.contentRenderer = createObject("component","#application.settingsManager.getSite(session.siteid).getAssetMap()#.includes.contentRenderer").init() />
</cfsilent>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<cfoutput>
<html>
	<head>
		<title>Select Link</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta content="noindex, nofollow" name="robots">
		<link href="#application.configBean.getContext()#/admin/css/admin.css" rel="stylesheet" type="text/css" />
		<script src="#application.configBean.getContext()#/admin/js/admin.js" type="text/javascript" language="Javascript"></script>
		<script src="#application.configBean.getContext()#/admin/js/prototype.js" type="text/javascript" language="Javascript"></script>
        <style>
			body {
				background: none;
			}
		</style>
</cfoutput>
</head>

<body scroll="no" style="OVERFLOW: hidden">
<cfoutput>
<h3>Keyword Search</h3>
<form id="siteSearch" name="siteSearch" method="post" onSubmit="return validateForm(this);"><input name="keywords" value="#attributes.keywords#" type="text" class="text" maxlength="50" required="true" message="The 'Keyword' field is required."/><!---<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.siteSearch);"><span>Search</span></a>--->
	<input type="hidden" name="fuseaction" value="cArch.search">
	<input type="hidden" name="siteid" value="#session.siteid#">
	<input type="hidden" name="moduleid" value="00000000000000000000000000000000000"><input  class="Button" type="submit" onClick="return submitForm(document.forms.siteSearch);" value="Search">
</form>
</cfoutput>
<form name="frmLinks" method="post" onSubmit="return false;">
<cfif attributes.keywords neq ''>
<div style="overflow:auto;width:549px;height:300px; ">
 <table id="metadata" class="stripe" style="margin-bottom: 2px;">
    <tr> 
      <th class="varWidth">Title</th>
	  <th class="administration">&nbsp;</th>
    </tr>
    <cfif request.rslist.recordcount>
     <cfoutput query="request.rslist" maxrows="#request.nextn.recordsperPage#" startrow="#attributes.startrow#">
		<cfset crumbdata=application.contentManager.getCrumbList(request.rslist.contentid, attributes.siteid)/>
        <tr>  
          <td class="varWidth"><label for="theLinks#request.rslist.currentrow#">#application.contentRenderer.dspZoomNoLinks(crumbdata,request.rsList.fileExt)#</label></td>
		  <td class="administration" id="test"><input type="radio" name="theLinks" id="theLinks#request.rslist.currentrow#" value="#htmlEditFormat(request.contentRenderer.createHREF(request.rslist.type,request.rslist.filename,session.siteid,request.rslist.contentid,request.rslist.target,request.rslist.targetParams,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile()))#^#htmleditformat(request.rslist.menutitle)#"<cfif request.rslist.currentrow eq 1> checked</cfif>></td>
		</tr>
       </cfoutput>
      <cfelse>
      <tr> 
        <td colspan="2" class="results"><em>Your search returned no results.</em></td>
      </tr>
    </cfif>
	
    <cfif request.nextn.numberofpages gt 1><tr> 
      <td colspan="7" class="results">More Results: <cfloop from="1"  to="#request.nextn.numberofpages#" index="i"><cfoutput><cfif request.nextn.currentpagenumber eq i> #i# <cfelse> <a href="?keywords=#attributes.keywords#&startrow=#evaluate('(#i#*#request.nextn.recordsperpage#)-#request.nextn.recordsperpage#+1')#">#i#</a> </cfif></cfoutput></cfloop></td></tr></cfif>
  </table>
</td></tr></table></div></cfif></form>
<script type="text/javascript" language="javascript">
stripe('stripe');
<cfif not ( len(attributes.keywords) and request.rslist.recordcount )>
document.forms.siteSearch.keywords.focus();
</cfif>
</script>

	</body>
</html>
<cfelse>
<cfoutput>
#application.pluginManager.renderScripts("onLinkSelect",session.siteid, createObject("component","mura.event").init(attributes) ,rsPluginScripts)#
</cfoutput>
</cfif>

