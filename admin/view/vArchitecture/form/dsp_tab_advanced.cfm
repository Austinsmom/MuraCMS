<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfset tabLabelList=listAppend(tabLabelList,application.rbFactory.getKeyValue(session.rb,"sitemanager.content.tabs.advanced"))/>
<cfset tabList=listAppend(tabList,"tabAdvanced")>
<cfoutput>
<div id="tabAdvanced">
<dl class="oneColumn">
<dt class="first">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.contentid')#</dt>
<dd><cfif len(attributes.contentID) and len(request.contentBean.getcontentID())>#request.contentBean.getcontentID()#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notavailable')#</cfif></dd>

<cfif listFind("Gallery,Link,Portal,Page,Calendar,File,Link",attributes.type)>
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.permlink')#</dt>
	<dd><cfif len(attributes.contentID) and len(request.contentBean.getcontentID())>http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()#/#attributes.siteid#/?LinkServID=#request.contentBean.getcontentID()#<cfelse>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.notavailable')#</cfif></dd>
	</dd>
</cfif>

<cfif attributes.type neq 'Component' and attributes.type neq 'Form'>
	<dt><cfoutput><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.layouttemplate')#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.layoutTemplate")#</span></a></cfoutput></dt>
	<dd><select name="template" class="dropdown">
	<cfif attributes.contentid neq '00000000000000000000000000000000001'>
		<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.inheritfromparent')#</option>
	</cfif>
	<cfloop query="request.rsTemplates">
	<cfif right(request.rsTemplates.name,4) eq ".cfm">
		<cfoutput>
		<option value="#request.rsTemplates.name#" <cfif request.contentBean.gettemplate() eq request.rsTemplates.name>selected</cfif>>#request.rsTemplates.name#</option>
		</cfoutput>
	</cfif>
	</cfloop>
	</select>
	</dd>
	<dt><cfoutput><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.altcascadetemplate')#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.altCascadeTemplate")#</span></a></cfoutput></dt>
	<dd><select name="altcascadetemplate" class="dropdown">
	<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.none')#</option>
	<cfloop query="request.rsTemplates">
	<cfif right(request.rsTemplates.name,4) eq ".cfm">
		<cfoutput>
		<option value="#request.rsTemplates.name#" <cfif request.contentBean.getAltCascadeTemplate() eq request.rsTemplates.name>selected</cfif>>#request.rsTemplates.name#</option>
		</cfoutput>
	</cfif>
	</cfloop>
	</select>
	</dd>
	<dt><input name="forceSSL" id="forceSSL" type="CHECKBOX" value="1" <cfif request.contentBean.getForceSSL() eq "">checked <cfelseif request.contentBean.getForceSSL() eq 1>checked</cfif> class="checkbox"> <label for="forceSSL"><a href="##" class="tooltip">#application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessltext'),application.rbFactory.getKeyValue(session.rb,'sitemanager.content.type.#attributes.type#'))#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.makePageSecure")#</span></a></label></dt>
	<dt><input name="searchExclude" id="searchExclude" type="CHECKBOX" value="1" <cfif request.contentBean.getSearchExclude() eq "">checked <cfelseif request.contentBean.getSearchExclude() eq 1>checked</cfif> class="checkbox"> <label for="searchExclude">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.searchexclude')#</label></dt>
	<dt><input name="mobileExclude" id="mobileExclude" type="CHECKBOX" value="1" <cfif request.contentBean.getMobileExclude() eq "">checked <cfelseif request.contentBean.getMobileExclude() eq 1>checked</cfif> class="checkbox"> <label for="mobileExclude">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mobileexclude')#</label></dt>
	
	<cfif application.settingsManager.getSite(attributes.siteid).getextranet()>
		<dt><input name="restricted" id="Restricted" type="CHECKBOX" value="1"  onclick="javascript: this.checked?toggleDisplay2('rg',true):toggleDisplay2('rg',false);" <cfif request.contentBean.getrestricted() eq 1>checked </cfif> class="checkbox">
		<label for="Restricted">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictaccess')#</label></dt>
		<!--- <dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.basicpermissions')#</dt> --->
		<dd id="rg"<cfif request.contentBean.getrestricted() NEQ 1> style="display:none;"</cfif>>
		<select name="restrictgroups" size="8" multiple="multiple" class="multiSelect" id="restrictGroups">
		<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.globalsettings'))#">
		<option value="" <cfif request.contentBean.getrestrictgroups() eq ''>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.allowall')#</option>
		<option value="RestrictAll" <cfif request.contentBean.getrestrictgroups() eq 'RestrictAll'>selected</cfif>>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.restrictall')#</option>
		</optgroup>
		<cfquery dbtype="query" name="rsGroups">select * from request.rsrestrictgroups where isPublic=1</cfquery>	
		<cfif rsGroups.recordcount>
			<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'user.membergroups'))#">
			<cfloop query="rsGroups">
				<option value="#rsGroups.groupname#" <cfif listfind(request.contentBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
			</cfloop>
			</optgroup>
		</cfif>
		<cfquery dbtype="query" name="rsGroups">select * from request.rsrestrictgroups where isPublic=0</cfquery>	
		<cfif rsGroups.recordcount>
			<optgroup label="#htmlEditFormat(application.rbFactory.getKeyValue(session.rb,'user.adminusergroups'))#">
			<cfloop query="rsGroups">
				<option value="#rsGroups.groupname#" <cfif listfind(request.contentBean.getrestrictgroups(),rsGroups.groupname)>Selected</cfif>>#rsGroups.groupname#</option>
			</cfloop>
			</optgroup>
		</cfif>
		</select>
		</dd>
	</cfif>
	
</cfif>

<cfif attributes.type eq 'Component' and request.rsTemplates.recordcount>
	<dt><cfoutput><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.layouttemplate')#<span>#application.rbFactory.getKeyValue(session.rb,"tooltip.layoutTemplate")#</span></a></cfoutput></dt>
	<dd><select name="template" class="dropdown">
	<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.none')#</option>
	<cfloop query="request.rsTemplates">
	<cfif right(request.rsTemplates.name,4) eq ".cfm">
	<cfoutput>
	<option value="#request.rsTemplates.name#" <cfif request.contentBean.getTemplate() eq request.rsTemplates.name>selected</cfif>>#request.rsTemplates.name#</option>
	</cfoutput>
	</cfif></cfloop>
	</select>
	</dd>
</cfif>

<cfif attributes.type eq 'Form' >
	<dt><input name="forceSSL" id="forceSSL" type="CHECKBOX" value="1" <cfif request.contentBean.getForceSSL() eq "">checked <cfelseif request.contentBean.getForceSSL() eq 1>checked</cfif> class="checkbox"> <label for="forceSSL">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.forcessl')#</label></dt>
	<dt><input name="displayTitle" id="displayTitle" type="CHECKBOX" value="1" <cfif request.contentBean.getDisplayTitle() eq "">checked <cfelseif request.contentBean.getDisplayTitle() eq 1>checked</cfif> class="checkbox"> <label for="displayTitle">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.displaytitle')#</label></dt>
</cfif>

<cfif application.settingsManager.getSite(attributes.siteid).getCache() and attributes.type eq 'Component' or attributes.type eq 'Form'>
	<dt><input name="doCache" id="doCache" type="CHECKBOX" value="0"<cfif request.contentBean.getDoCache() eq 0> checked</cfif> class="checkbox"> <label for="cacheItem">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.docache')#</label></dt>
</cfif>
 
<cfif  attributes.contentid neq '00000000000000000000000000000000001' and listFind(session.mura.memberships,'S2')>
	<dt><input name="isLocked" id="islocked" type="CHECKBOX" value="1" <cfif request.contentBean.getIsLocked() eq "">checked <cfelseif request.contentBean.getIsLocked() eq 1>checked</cfif> class="checkbox"> <label for="islocked">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.locknode')#</label></dt>
</cfif>

<cfif attributes.type eq 'Portal' or attributes.type eq 'Calendar' or attributes.type eq 'Gallery'>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</dt>
	<dd><select name="imageSize" class="dropdown" onchange="if(this.value=='Custom'){jQuery('##CustomImageOptions').fadeIn('fast')}else{jQuery('##CustomImageOptions').hide()}">
		<cfloop list="Small,Medium,Large,Custom" index="i">
		<option value="#i#"<cfif i eq request.contentBean.getImageSize()> selected</cfif>>#I#</option>
		</cfloop>
	</select>
	</dd>
	<dd id="CustomImageOptions"<cfif request.contentBean.getImageSize() neq "Custom"> style="display:none"</cfif>>
	<dl>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</dt>
	<dd><input name="imageHeight" class="text" value="#request.contentBean.getImageHeight()#" /></dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</dt>
	<dd><input name="imageWidth" class="text" value="#request.contentBean.getImageWidth()#" /></dd>
	</dl>
</dd>
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.recordsperpage')#</dt>
	<dd><select name="nextN" class="dropdown">
		<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
			<option value="#r#" <cfif r eq request.contentBean.getNextN()>selected</cfif>>#r#</option>
		</cfloop>
		</select>
	</dd>
</cfif>

<cfif (attributes.type neq 'Component' and attributes.type neq 'Form') and request.contentBean.getcontentID() neq '00000000000000000000000000000000001'>
	<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteinformation')#</dt>
	<dd id="editRemote">
		<dl>
		<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteid')#</dt>
		<dd><input type="text" id="remoteID" name="remoteID" value="#request.contentBean.getRemoteID()#"  maxlength="255" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remoteurl')#</dt>
		<dd><input type="text" id="remoteURL" name="remoteURL" value="#request.contentBean.getRemoteURL()#"  maxlength="255" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotepublicationdate')#</dt>
		<dd><input type="text" id="remotePubDate" name="remotePubDate" value="#request.contentBean.getRemotePubDate()#"  maxlength="255" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesource')#</dt>
		<dd><input type="text" id="remoteSource" name="remoteSource" value="#request.contentBean.getRemoteSource()#"  maxlength="255" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotesourceurl')#</dt>
		<dd><input type="text" id="remoteSourceURL" name="remoteSourceURL" value="#request.contentBean.getRemoteSourceURL()#"  maxlength="255" class="text"></dd>
		</dl>
	</dd>
</cfif>
</dl>
</div>
</cfoutput>