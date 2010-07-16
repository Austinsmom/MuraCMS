<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->
<cfset tabLabelList="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.basic')#,#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.usagereport')#">
<cfset tabList="tabBasic,tabUsagereport">
<cfoutput><form action="index.cfm?fuseaction=cMailingList.update" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);">
<h2>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager')#</h2>
<cfif attributes.mlid neq ''><ul id="navTask">
<li><a href="index.cfm?fuseaction=cMailingList.listmembers&mlid=#attributes.mlid#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.vieweditmembers')#</a></li>
<li><a href="index.cfm?fuseaction=cMailingList.download&mlid=#attributes.mlid#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.downloadmembers')#</a></li>
</ul></cfif>
<dl class="oneColumn"><cfif request.listBean.getispurge() neq 1>
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.name')#</dt>
<dd><input type=text name="Name" value="#HTMLEditFormat(request.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#" class="text"></dd>
<cfif attributes.mlid neq ''>
</dl>
<div class="tabs initActiveTab">
<ul>
<cfloop from="1" to="#listlen(tabList)#" index="t">
<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
</cfloop>
</ul>
<div id="tabBasic">
<dl class="oneColumn">
<dt class="first">
<cfelse>
<dt>
</cfif>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.type')#</dt>
<dd>
<input type="radio" value="1" id="isPublicYes" name="isPublic" <cfif request.listBean.getisPublic() eq 1>checked</cfif>> <label for="isPublicYes">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.public')#</label> <input type="radio" value="0" id="isPublicNo" name="isPublic" <cfif request.listBean.getisPublic() neq 1>checked</cfif>> <label for="isPublicNo">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.private')#</label>
<input type=hidden name="ispurge" value="0">
</dd>
<dt>
<cfelse>
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.masterdonotemaillistname')#</dt>
<dd><input type=text name="Name" value="#HTMLEditFormat(request.listBean.getname())#" required="true" message="#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.namerequired')#" class="text"> <input type=hidden name="ispurge" value="1"><input type=hidden name="ispublic" value="1"></dd>
</dl>
<div class="tabs">
<ul>
<cfloop from="1" to="#listlen(tabList)#" index="t">
<li><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
</cfloop>
</ul>
<div id="tabBasic">
<dl class="oneColumn">
<dt class="first">
</cfif>
#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.description')#</dt>
<dd><textarea id="description" name="description" cols="17" rows="7" class="alt">#HTMLEditFormat(request.listBean.getdescription())#</textarea><input type=hidden name="siteid" value="#HTMLEditFormat(attributes.siteid)#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploadlistmaintenancefile')#</dt>
<dd><input type="radio" name="direction" id="da" value="add" checked> <label for="da">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.addaddressestolist')#</label></dd>
<dd><input type="radio" name="direction" id="dm" value="remove"> <label for="dm">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.removeaddressesfromlist')#</label></dd>
<dd><input type="radio" name="direction" id="dp" value="replace"> <label for="dp">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.replaceemaillistwithnewfile')#</label></dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.uploademailaddressfile')#</dt>
<dd><input type="file" name="listfile" accept="text/html,test/plain" ></dd>
<cfif attributes.mlid neq ''>
<dt><input type="checkbox" id="cm" name="clearMembers" value="1" /> <label for="cm">#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.clearoutexistingmembers')#</label></dt>
</cfif></dl>      
<cfif attributes.mlid neq ''>
</div>
<cfinclude template="dsp_tab_usage.cfm">
</div>
</cfif>  			
<cfif attributes.mlid eq ''>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.add')#</span></a><input type=hidden name="mlid" value="#createuuid()#"><cfelse><cfif not request.listBean.getispurge()><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.deleteconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.delete')#</span></a></cfif> <a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.update')#</span></a>
<input type=hidden name="mlid" value="#request.listBean.getmlid()#"></cfif><input type="hidden" name="action" value=""></form></cfoutput>
<!---
<cfif attributes.mlid neq ''>
<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<cfoutput><script type="text/javascript">
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'mailinglistmanager.usagereport'))#"),0,0,0);
</script></cfoutput>
</cfif>--->