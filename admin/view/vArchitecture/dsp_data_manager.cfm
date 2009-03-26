<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfsilent>
<cfhtmlhead text="#session.dateKey#">
<cfparam name="session.datakeywords" default="">
<cfparam name="attributes.keywords" default="">
<cfparam name="attributes.filterBy" default="">
<cfparam name="session.filterBy" default="">

<cfif isDefined('attributes.newSearch')>
<cfset session.filterBy=attributes.filterBy />
<cfset session.datakeywords=attributes.keywords />
</cfif>

<cfparam name="attributes.sortBy" default="#request.contentBean.getSortBy()#">
<cfparam name="attributes.sortDirection" default="#request.contentBean.getSortDirection()#">

<cfset request.perm=application.permUtility.getnodePerm(request.crumbdata)>

<cfif isDefined('attributes.responseid') and attributes.action eq 'Update'>
	<cfset application.dataCollectionManager.update(attributes)/>
<cfelseif isDefined('attributes.responseid') and attributes.action eq 'Delete'>
	<cfset application.dataCollectionManager.delete('#attributes.responseID#')/>
<cfelseif  attributes.action eq 'setDisplay'>
	<cfset request.contentBean.setResponseDisplayFields(attributes.responseDisplayFields)/>
	<cfset request.contentBean.setNextN(attributes.nextn)/>
	<cfset request.contentBean.setSortBy(attributes.sortBy)/>
	<cfset request.contentBean.setSortDirection(attributes.sortDirection)/>
	<cfset application.dataCollectionManager.setDisplay(request.contentBean)/>
	<cfset attributes.action=""/>
</cfif>
<cfset request.rsDataInfo=application.contentManager.getDownloadselect(attributes.contentid,attributes.siteid) />
<cfset attributes.fieldnames=application.dataCollectionManager.getCurrentFieldList(attributes.contentid)/>>
</cfsilent>
<cfoutput><h2>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</h2>
<ul id="navTask">
<li><a href="index.cfm?fuseaction=cArch.hist&contentid=#attributes.contentid#&type=Form&parentid=00000000000000000000000000000000004&topid=00000000000000000000000000000000004&siteid=#attributes.siteid#&startrow=#attributes.startrow#&moduleid=00000000000000000000000000000000004">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.versionhistory')#</a> </li>
<cfif attributes.action neq ''>
<li><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedate')#" href="index.cfm?fuseaction=cArch.datamanager&contentid=#attributes.ContentID#&type=Form&topid=00000000000000000000000000000000004&siteid=#attributes.siteid#&moduleid=00000000000000000000000000000000004&parentid=00000000000000000000000000000000004">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.managedata')#</a></li>
</cfif>
<cfif request.perm eq 'editor'>
<li><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.editdisplay')#" href="index.cfm?fuseaction=cArch.datamanager&contentid=#attributes.ContentID#&type=Form&action=display&topid=00000000000000000000000000000000004&siteid=#attributes.siteid#&moduleid=00000000000000000000000000000000004&parentid=00000000000000000000000000000000004">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.editdisplay')#</a></li>
<li><a title="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.delete')#" href="index.cfm?fuseaction=cArch.update&contentid=#attributes.ContentID#&type=Form&action=deleteall&topid=00000000000000000000000000000000004&siteid=#attributes.siteid#&moduleid=00000000000000000000000000000000004&parentid=00000000000000000000000000000000004" onClick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deleteformconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deleteform')#</a></li>
</cfif>
<cfif isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or isUserInRole('S2')><li><a href="index.cfm?fuseaction=cPerm.main&contentid=#attributes.ContentID#&type=Form&parentid=00000000000000000000000000000000004&topid=00000000000000000000000000000000004&siteid=#attributes.siteid#&moduleid=00000000000000000000000000000000004&startrow=#attributes.startrow#">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.permissions')#</a></li></cfif>
</ul>

<ul class="overview"><li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.title')#: <strong>#request.contentBean.gettitle()#</strong></li>
<li>#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.totalrecordsavailable')#: <strong>#request.rsDataInfo.CountEntered#</strong></li>
</ul></cfoutput>

<cfif attributes.action eq "edit">
<cfinclude template="data_manager/dsp_edit.cfm">
<cfelseif attributes.action eq "display">
<cfinclude template="data_manager/dsp_display.cfm">
<cfelse>
<cfinclude template="data_manager/dsp_response.cfm">
</cfif>




