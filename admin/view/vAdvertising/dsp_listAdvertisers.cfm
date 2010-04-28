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
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'advertising.viewadvertisers')#</h2>

<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,'advertising.advertisersearch')#</h3><form id="siteSearch" name="siteSearch" method="get"><input name="keywords" value="#HTMLEditFormat(attributes.keywords)#" type="text" class="text" maxlength="50" />  
	
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.siteSearch);"><span>#application.rbFactory.getKeyValue(session.rb,'advertising.search')#</span></a>
	<input type="hidden" name="fuseaction" value="cAdvertising.listAdvertisers">
	<input type="hidden" name="siteid" value="#HTMLEditFormat(attributes.siteid)#">
</form>
<!--- 
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cPublicUsers.editUser&userid=&siteid=#URLEncodedFormat(attributes.siteid)#&groupid=#application.advertiserManager.getGroupID(attributes.siteid)#&routeid=adManager">Add Advertiser</li>
</ul> --->

<table class="stripe">
<tr>
	<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'advertising.advertiser')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.contact')#</th>
	<th>#application.rbFactory.getKeyValue(session.rb,'advertising.email')#</th>
	<th class="administration">&nbsp;</th>
</tr></cfoutput>
<cfif request.rslist.recordcount>
<cfoutput query="request.rslist">
	<tr>
		<td class="varWidth"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.viewAdvertiser&userid=#request.rslist.userid#&siteid=#URLEncodedFormat(attributes.siteid)#">#company#</a></td>
		<td>#fname# #lname#</td>
		<td><cfif email neq ''><a href="mailto:#email#">#email#</a><cfelse>&nbsp;</cfif></td>
		<td class="administration"><ul class="advertisers"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#" href="index.cfm?fuseaction=cAdvertising.viewAdvertiser&userid=#request.rslist.userid#&siteid=#URLEncodedFormat(attributes.siteid)#">#application.rbFactory.getKeyValue(session.rb,'advertising.edit')#</a></li></ul></td></tr>
</cfoutput>
<cfelse>
<tr>
		<td nowrap class="noResults" colspan="5"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'advertising.noadvertisers')#</cfoutput></td>
	</tr>
</cfif>
</table>