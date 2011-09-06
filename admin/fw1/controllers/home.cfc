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
<cfcomponent extends="controller" output="false">

	<cffunction name="init" output="false">
		<cfargument name="fw" />
		<cfset variables.fw = arguments.fw />
	</cffunction>

	<cffunction name="setContentServer" output="false">
	<cfargument name="ContentServer">
	<cfset variables.contentServer=arguments.contentServer>
	</cffunction>
	
	<cffunction name="redirect" output="false">
		<cfargument name="rc" />
		<cfset var siteID="">
		<cfset var rsList="">
		<cfset var rsDefault=structNew()>
		
		<cfset arguments.rc.siteid="">
		<cfif not listFind(session.mura.memberships,'S2IsPrivate')>
			<cfset variables.fw.redirect(action="clogin.main",path="index.cfm")>
		</cfif>
		
		<cfset rsList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
		
		<cfset siteID=application.contentServer.bindToDomain(isAdmin=true)>
		
		<cfif siteID neq "--none--">
			<cfquery name="rsDefault" dbtype="query">
			SELECT siteid FROM rsList
			WHERE siteid = <cfqueryparam cfsqltype="cf_sql_varchar"
			value="#siteID#" />
			</cfquery>
		<cfelse>
			<cfset rsDefault.recordcount=0>
		</cfif>
		
		<cfif rsDefault.recordcount>
			<cfset arguments.rc.siteid=rsDefault.siteid />
		<cfelseif rsList.recordcount>
			<cfset arguments.rc.siteid=rsList.siteid />
		</cfif>
		
		<cfif len(arguments.rc.siteid)>
			<cfif application.configBean.getDashboard()>
				<cfset variables.fw.redirect(action="cDashboard.main",append="siteid",path="index.cfm")>
			<cfelse>
				<cfset arguments.rc.moduleid="00000000000000000000000000000000000">
				<cfset arguments.rc.topid="00000000000000000000000000000000001">
				<cfset variables.fw.redirect(action="cArch.list",append="siteid,moduleid,topid",path="index.cfm")>
			</cfif>
		</cfif>
		
		<cfset variables.fw.redirect(action="cMessage.noAccess",path="index.cfm")>

	</cffunction>

</cfcomponent>