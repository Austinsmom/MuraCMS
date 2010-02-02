<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.configBean="">
<cfset variables.settingsManager="">
<cfset variables.pluginManager="">

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="configBean">
	<cfargument name="settingsManager">
	<cfargument name="pluginManager">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.settingsManager=arguments.settingsManager />
	<cfset variables.pluginManager=arguments.pluginManager />
	
<cfreturn this />
</cffunction>

<cffunction name="displayObject" output="true" returntype="any">
<cfargument name="objectID">
<cfargument name="event">
<cfargument name="rsDisplayObject">
<cfargument name="$">
<cfargument name="mura">

	<cfset var rs=""/>
	<cfset var str=""/>
	<cfset var pluginConfig=""/>
	
	<cfset request.pluginConfig=variables.pluginManager.getConfig(arguments.rsDisplayObject.pluginID)>
	<cfset request.pluginConfig.setSetting("pluginMode","object")/>
	<cfset request.scriptEvent=arguments.event />
	<cfset pluginConfig=request.pluginConfig/>
	
	<cfif arguments.rsDisplayObject.location eq "global">
	
	<cfset pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/plugins/#pluginConfig.getDirectory()#/")/>

	<cfsavecontent variable="str">
	<cfinclude template="/#variables.configBean.getWebRootMap()#/plugins/#pluginConfig.getDirectory()#/#arguments.rsDisplayObject.displayObjectFile#">
	</cfsavecontent>
	<cfelse>
	
	<cfset pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/#variables.settingsManager.getSite(event.getValue('siteID')).getDisplayPoolID()#/includes/plugins/#pluginConfig.getDirectory()#/")/>
	<cfsavecontent variable="str">
	<cfinclude template="/#variables.configBean.getWebRootMap()#/#variables.settingsManager.getSite(event.getValue('siteID')).getDisplayPoolID()#/includes/plugins/#pluginConfig.getDirectory()#/#arguments.rsDisplayObject.displayObjectFile#">
	</cfsavecontent>
	</cfif>
	
	<cfset structDelete(request,"pluginConfig")>
	<cfset structDelete(request,"scriptEvent")>
	
	<cfreturn trim(str) />
</cffunction>

<cffunction name="executeScript" output="false" returntype="any">
<cfargument name="event" required="true" default="" type="any">
<cfargument name="scriptFile" required="true" default="" type="any">
<cfargument name="pluginConfig" required="true" default="" type="any">
<cfargument name="$">
<cfargument name="mura">
	<cfset var scriptEvent=arguments.event>
	<cfset request.pluginConfig=arguments.pluginConfig/>
	<cfset request.scriptEvent=arguments.event/>
	<cfinclude template="#arguments.scriptFile#">
	<cfset structDelete(request,"pluginConfig")>
	<cfset structDelete(request,"scriptEvent")>
	<cfreturn event/>

</cffunction>

<cffunction name="renderScript" output="true" returntype="any">
<cfargument name="event" required="true" default="" type="any">
<cfargument name="scriptFile" required="true" default="" type="any">
<cfargument name="pluginConfig" required="true" default="" type="any">
<cfargument name="$">
<cfargument name="mura">
	<cfset var rs=""/>
	<cfset var str=""/>
	
	<cfset request.pluginConfig=arguments.pluginConfig/>
	<cfset request.pluginConfig.setSetting("pluginMode","object")/>
	<cfset request.scriptEvent=arguments.event />
	<cfset pluginConfig.setSetting("pluginPath","#variables.configBean.getContext()#/plugins/#pluginConfig.getDirectory()#/")/>
	<cfset attributes=arguments.event.getAllValues()/>
	<cfsavecontent variable="str">
	<cfinclude template="#arguments.scriptFile#">
	</cfsavecontent>
	
	<cfset structDelete(request,"pluginConfig")>
	<cfset structDelete(request,"scriptEvent")>
	
	<cfreturn trim(str) />
</cffunction>

</cfcomponent>