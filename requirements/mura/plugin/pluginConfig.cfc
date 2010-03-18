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
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.settings=structNew() />
<cfset variables.name="" />
<cfset variables.deployed=0 />
<cfset variables.pluginID=0 />
<cfset variables.loadPriority=5 />
<cfset variables.moduleID="" />
<cfset variables.provider="" />
<cfset variables.providerURL="" />
<cfset variables.created="" />
<cfset variables.category="" />
<cfset variables.version="" />
<cfset variables.package="" />
<cfset variables.directory="" />

<cffunction name="initSettings" returntype="any" access="public" output="false">
	<cfargument name="data"  type="any" default="#structNew()#">
	
	<cfset variables.settings=arguments.data />
	
	<cfreturn this />
</cffunction>

<cffunction name="getModuleID" returntype="String" access="public" output="false">
	<cfreturn variables.moduleID />
</cffunction>

<cffunction name="setModuleID" access="public" output="false">
	<cfargument name="moduleID" type="String" />
	<cfset variables.moduleID = trim(arguments.moduleID) />
</cffunction>

<cffunction name="setPluginID" access="public" output="false">
	<cfargument name="pluginID" />
	<cfif isnumeric(arguments.pluginID)>
	<cfset variables.pluginID = arguments.pluginID />
	</cfif>
</cffunction>

<cffunction name="getPluginID" returntype="numeric" access="public" output="false">
	<cfreturn variables.pluginID />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.name = trim(arguments.name) />
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.name />
</cffunction>

<cffunction name="setProvider" access="public" output="false">
	<cfargument name="provider" type="String" />
	<cfset variables.provider = trim(arguments.provider) />
</cffunction>

<cffunction name="getProvider" returntype="String" access="public" output="false">
	<cfreturn variables.provider />
</cffunction>

<cffunction name="setProviderURL" access="public" output="false">
	<cfargument name="providerURL" type="String" />
	<cfset variables.providerURL = trim(arguments.providerURL) />
</cffunction>

<cffunction name="getProviderURL" returntype="String" access="public" output="false">
	<cfreturn variables.providerURL />
</cffunction>

<cffunction name="setLoadPriority" access="public" output="false">
	<cfargument name="loadPriority" />
	<cfif isNumeric(arguments.loadPriority)>
		<cfset variables.loadPriority = arguments.loadPriority >
	</cfif>
</cffunction>

<cffunction name="getLoadPriority" access="public" output="false">
	<cfreturn variables.loadPriority />
</cffunction>

<cffunction name="setCategory" access="public" output="false">
	<cfargument name="category" type="String" />
	<cfset variables.category = trim(arguments.category) />
</cffunction>

<cffunction name="getCategory" returntype="String" access="public" output="false">
	<cfreturn variables.category />
</cffunction>

<cffunction name="setCreated" access="public" output="false">
	<cfargument name="created" type="String" />
	<cfset variables.created = trim(arguments.created) />
</cffunction>

<cffunction name="getCreated" returntype="String" access="public" output="false">
	<cfreturn variables.created />
</cffunction>

<cffunction name="setDeployed" access="public" output="false">
	<cfargument name="deployed" />
	<cfif isNumeric(arguments.deployed)>
	<cfset variables.deployed = arguments.deployed />
	</cfif>
</cffunction>

<cffunction name="getDeployed" returntype="numeric" access="public" output="false">
	<cfreturn variables.deployed />
</cffunction>

<cffunction name="setVersion" access="public" output="false">
	<cfargument name="version" type="String" />
	<cfset variables.version = trim(arguments.version) />
</cffunction>

<cffunction name="getVersion" returntype="String" access="public" output="false">
	<cfreturn variables.version />
</cffunction>

<cffunction name="setPackage" access="public" output="false">
	<cfargument name="package" type="String" />
	<cfset variables.package = trim(arguments.package) />
</cffunction>

<cffunction name="getPackage" returntype="String" access="public" output="false">
	<cfreturn variables.package />
</cffunction>

<cffunction name="setDirectory" access="public" output="false">
	<cfargument name="directory" type="String" />
	<cfset variables.directory = trim(arguments.directory) />
</cffunction>

<cffunction name="getDirectory" returntype="String" access="public" output="false">
	<cfreturn variables.directory />
</cffunction>

<cffunction name="setSetting" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	
	<cfset variables.settings["#arguments.property#"]=arguments.propertyValue />

</cffunction>

<cffunction name="getSetting" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
	
	<cfif structKeyExists(variables.settings,"#arguments.property#")>
		<cfreturn variables.settings["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="getSettings" returntype="any" access="public" output="false">
		<cfreturn variables.settings />
</cffunction>

<cffunction name="addToHTMLHeadQueue" output="false">
<cfargument name="text">
	
<cfset var headerStr=""/>
<cfset var pluginPath=""/>
<cfset var pluginConfig=this>
<cfset var event="">
<cfset var eventData=structNew()>	

<cfif structKeyExists(request,"servletEvent")> and structKeyExists(request,"contentRenderer")>
	<cfset request.contentRenderer.addtoHTMLHeadQueue(getDirectory() & "/" & arguments.text) />
<cfelse>
<cfif structKeyExists(request,"servletEvent")>
	<cfset event=request.servletEvent>
<cfelse>
	<cfif structKeyExists(session,"siteid")>
		<cfset eventData.siteID=session.siteid>
	</cfif>
	<cfset event=createObject("component","mura.event").init(eventData)>
</cfif>
<cfset pluginPath= application.configBean.getContext() & "/plugins/" & getDirectory() & "/" >		
<cfsavecontent variable="headerStr">
<cfinclude template="/#application.configBean.getWebRootMap()#/plugins/#getDirectory()#/#arguments.text#">
</cfsavecontent>
<cfhtmlhead text="#headerStr#">	
</cfif>
	
</cffunction>

<cffunction name="getApplication" returntype="any" access="public" output="false">
<cfargument name="purge" default="false">
		

		<cfif not structKeyExists(application,"plugins")>
			<cfset application.plugins=structNew()>
		</cfif>
		
		<cfif not structKeyExists(application.plugins,"p#getPluginID()#")>
			<cfset application.plugins["p#getPluginID()#"]=createObject("component","pluginApplication")>
			<cfset application.plugins["p#getPluginID()#"].setPluginConfig(this)>
		<cfelse>
			<cfif arguments.purge>
			<cfset structDelete(application.plugins, "p#getPluginID()#")>
			<cfset application.plugins["p#getPluginID()#"]=createObject("component","pluginApplication")>
			<cfset application.plugins["p#getPluginID()#"].setPluginConfig(this)>
			</cfif>
		</cfif>
		
		<cfreturn application.plugins["p#getPluginID()#"] />
</cffunction>

<cffunction name="getSession" returntype="any" access="public" output="false">
	
		<cfif not structKeyExists(session,"plugins")>
			<cfset session.plugins=structNew()>
		</cfif>
		
		<cfif not structKeyExists(session.plugins,"p#getPluginID()#")>
			<cfset session.plugins["p#getPluginID()#"]=createObject("component","pluginSession")>
		</cfif>
		
		<cfreturn session.plugins["p#getPluginID()#"] />
</cffunction>

<cffunction name="addEventHandler" output="false" returntype="void">
	<cfargument name="component" required="true">
    <cfset var rsSites=getPluginManager().getAssignedSites(getModuleID())>
    <cfloop query="rsSites">
    <cfset getPluginManager().addEventHandler(arguments.component,rsSites.siteID)>
    </cfloop>
</cffunction>

<cffunction name="getAssignedSites" output="false" returntype="any">
    <cfreturn getPluginManager().getAssignedSites(getModuleID())>
</cffunction>

</cfcomponent>

