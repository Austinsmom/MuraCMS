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