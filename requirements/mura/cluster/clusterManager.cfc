<cfcomponent extends="mura.cfobject">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfset variables.configBean=arguments.configBean />
<cfreturn this />
</cffunction>

<cffunction name="purgeCache" returntype="void" access="public" output="false">
	<cfargument name="siteid" required="true" default="">
	<cfset var clusterList=getClusterList()>
	<cfset var host="">
	<cfset var remoteURL="">
	
	<cfif len(clusterList)>
		<cfloop list="#clusterList#" index="host">
			<cfif host neq cgi.server_name>
				<cfset remoteURL="#formatHost(host)#/MuraProxy.cfc?method=purgeSiteCache&siteID=#URLEncodedFormat(arguments.siteID)#&appreloadkey=siteID=#URLEncodedFormat(application.appreloadkey)#">
				<cfset doRemoteCall(remoteURL)>
			</cfif>
		</cfloop>
	</cfif>
	
</cffunction>

<cffunction name="reload" output="false" returntype="void">	
	<cfset var clusterList=getClusterList()>
	<cfset var host="">
	
	<cfif len(clusterList)>
		<cfloop list="#clusterList#" index="host">
			<cfif host neq cgi.server_name>
				<cfset remoteURL="#formatHost(host)#/MuraProxy.cfc?method=reload&&appreloadkey=#URLEncodedFormat(application.appreloadkey)#">
				<cfset doRemoteCall(remoteURL)>
			</cfif>
		</cfloop>
	</cfif>
	
</cffunction>	

<cffunction name="getClusterList" output="false">
	<cfset var clusterList=variables.configBean.getValue("clusterList")>
	<!--- for backward compatbility look for clusterIPlist if clusterList is not set --->
	<cfif not len(clusterList)>
		<cfset  clusterList=variables.configBean.getValue("clusterIPList")>
	</cfif>
	<cfreturn clusterList>
</cffunction>

<cffunction name="doRemoteCall" output="false">
<cfargument name="remoteURL">
	<cfif len(variables.configBean.getProxyServer())>
		<cfhttp url="#remoteURL#" 
				proxyUser="#variables.configBean.getProxyUser()#" proxyPassword="#variables.configBean.getProxyPassword()#"
				proxyServer="#variables.configBean.getProxyServer()#" proxyPort="#variables.configBean.getProxyPort()#">
	<cfelse>
		<cfhttp url="#remoteURL#">
	</cfif>
</cffunction>

<cffunction name="formatHost" output="false">
	<cfargument name="host">
	<cfif left(host,4) neq "http">
		<cfset host="http://" & host>
	</cfif>
	<cfif listLen(host,":") neq 3>
		<cfset host = host & variables.configBean.getServerPort()>
	</cfif>
	<cfreturn host & variables.configBean.getContext()>
</cffunction>

</cfcomponent>