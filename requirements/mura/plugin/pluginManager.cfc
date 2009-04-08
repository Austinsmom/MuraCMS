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
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.configBean="">
<cfset variables.settingsManager="">
<cfset variables.utility="">
<cfset variables.genericManager="">
<cfset variables.eventManagers=structNew()>
<cfset variables.cacheFactories=structNew()>

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="configBean">
	<cfargument name="settingsManager">
	<cfargument name="utility">
	<cfargument name="genericManager">
	
	<cfset setConfigBean(arguments.configBean)>
	<cfset setSettingsManager(arguments.settingsManager)>
	<cfset setUtility(arguments.utility)>
	<cfset setGenericManager(arguments.genericManager)>
	
<cfreturn this />
</cffunction>

<cffunction name="setConfigBean" returntype="void" access="public" output="false">
<cfargument name="configBean">
<cfset variables.configBean=arguments.configBean />

<cfset loadPlugins()>

</cffunction>

<cffunction name="setSettingsManager" returntype="void" access="public" output="false">
<cfargument name="settingsManager">
<cfset variables.settingsManager=arguments.settingsManager />
</cffunction>

<cffunction name="setGenericManager" returntype="void" access="public" output="false">
<cfargument name="genericManager">
<cfset variables.genericManager=arguments.genericManager />
</cffunction>

<cffunction name="setUtility" returntype="void" access="public" output="false">
<cfargument name="utility">
<cfset variables.utility=arguments.utility />
</cffunction>

<cffunction name="loadPlugins" returntype="void" access="public" output="false">
<cfset var rsScripts1="">
<cfset var rsScripts2="">

<cfquery name="variables.rsPlugins" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select * from tplugins
</cfquery>

<cfquery name="variables.rsSettings" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select * from tpluginsettings
</cfquery>

<cfquery name="rsScripts1" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select tplugins.name,tpluginscripts.moduleID, tplugins.pluginID, tpluginscripts.runat, tpluginscripts.scriptfile, 
tcontent.siteID, tpluginscripts.docache from tpluginscripts
inner join tplugins on (tpluginscripts.moduleID=tplugins.moduleID)
inner join tcontent on (tplugins.moduleID=tcontent.moduleID)
where tpluginscripts.runat not in ('onGlobalLogin','onGlobalRequestStart','onApplicationLoad')
and tplugins.deployed=1
</cfquery>

<cfquery name="rsScripts2" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select tplugins.name,tpluginscripts.moduleID, tplugins.pluginID, tpluginscripts.runat, tpluginscripts.scriptfile, '' siteID, tpluginscripts.docache from tpluginscripts
inner join tplugins on (tpluginscripts.moduleID=tplugins.moduleID)
where tpluginscripts.runat in ('onGlobalLogin','onGlobalRequestStart','onApplicationLoad')
and tplugins.deployed=1
</cfquery>


<cfquery name="variables.rsScripts" dbtype="query">
select * from rsScripts1
union
select * from rsScripts2
</cfquery>

<cfquery name="variables.rsDisplayObjects" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select tplugindisplayobjects.objectID, tplugindisplayobjects.moduleID, tplugindisplayobjects.name, 
tplugindisplayobjects.displayObjectfile, tplugins.pluginID, tcontent.siteID, tcontent.title,
tplugindisplayobjects.location, tplugindisplayobjects.displaymethod, tplugindisplayobjects.docache
from tplugindisplayobjects inner join tplugins on (tplugindisplayobjects.moduleID=tplugins.moduleID)
inner join tcontent on (tplugins.moduleID=tcontent.moduleID)
</cfquery>

<cfset purgeEventManagers()/>
<cfset purgeCacheFactories()/>

</cffunction>

<cffunction name="getLocation" returntype="string" access="public" output="false">
<cfargument name="pluginID">
<cfset var delim=variables.configBean.getFileDelim() />
<cfreturn "#variables.configBean.getWebRoot()##delim#plugins#delim##arguments.pluginID##delim#">
</cffunction>

<cffunction name="getAllPlugins" returntype="query" access="public" output="false">
<cfset var rs="">
<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select * from tplugins order by pluginID
</cfquery>
<cfreturn rs/>
</cffunction>

<cffunction name="deploy" returntype="any" access="public" output="false">
<cfargument name="moduleID" required="true" default="">

<cfset var delim=variables.configBean.getFileDelim() />
<cfset var location="">
<cfset var modID=arguments.moduleID />
<cfset var rsPlugin="" />
<cfset var pluginXML="" />
<cfset var scriptsLen=0 />
<cfset var eventHandlersLen=0 />
<cfset var objectsLen=0 />
<cfset var i=1 />
<cfset var displayObject="" />
<cfset var script="" />
<cfset var eventHandler=""/>
<cfset var isNew=false />
<cfset var zipTool=createObject("component","mura.Zip")>

<cflock name="addPlugin" timeout="200">
	<!--- <cftry> --->
	<cfif not len(modID)>
		<cfset isNew=true/>
		<cfset modID=createUUID()/>	
	<cfelse>
		<cfset deleteScripts(modID) />
	</cfif>
	
	<cffile action="upload" filefield="NewPlugin" nameconflict="makeunique" destination="#getTempDirectory()#">	
	
	<cfif isNew>
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	insert into tplugins (moduleID,name,provider,providerURL,version,deployed,category,created) values (
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#modID#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" value="An error occurred.">,
	null,
	null,
	null,
	0,
	null,
	#createODBCDateTime(now())#
	)
	</cfquery>
	</cfif>
	
	<cfset rsPlugin=getPlugin(modID,false) />
	
	<cfset location=getLocation(rsPlugin.pluginID) />
	
	<cfif directoryExists(location)>
		<cfdirectory action="delete" directory="#location#" recurse="true">
	</cfif>
	
	<cfdirectory action="create" directory="#location#" mode="777">
	
	<cfset zipTool.extract("#getTempDirectory()##delim##file.serverfile#","#location#")>
	
	<cffile action="delete" file="#getTempDirectory()##delim##file.serverfile#">
	
</cflock>

<cfset savePluginXML(modID) />
<cfset loadPlugins() />

<cfreturn modID/>

</cffunction>

<cffunction name="savePluginXML" output="false" access="public">
<cfargument name="modID">

	<cfset var scriptsLen=0 />
	<cfset var eventHandlersLen=0 />
	<cfset var objectsLen=0 />
	<cfset var i=1 />
	<cfset var displayObject="" />
	<cfset var script="" />
	<cfset var eventHandler=""/>
	<cfset var rsPlugin=getPlugin(modID,false) />
	<cfset var location=getLocation(rsPlugin.pluginID) />
	<cfset var delim=variables.configBean.getFileDelim() />
	<cfset var pluginXML=getPluginXML(modID)>

	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tplugins set
	name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.name.xmlText#">,
	provider=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.provider.xmlText#">,
	providerURL=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.providerURL.xmlText#">,
	version=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.version.xmlText#">,
	category=<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.category.xmlText#">,
	created=#createODBCDateTime(now())#
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#modID#">
	</cfquery>
	
	<cfif structKeyExists(pluginXML.plugin,"scripts")>
		<cfif structKeyExists(pluginXML.plugin.scripts,"script")>
			<cfset scriptsLen=arraylen(pluginXML.plugin.scripts.script)/>
				<cfif scriptsLen>
					<cfloop from="1" to="#scriptsLen#" index="i">
						<cfset script=getScriptBean() />
						<cfset script.setModuleID(modID) />>
						<cfif structKeyExists(pluginXML.plugin.scripts.script[i].xmlAttributes,"runat")>
							<cfset script.setRunAt(pluginXML.plugin.scripts.script[i].xmlAttributes.runat) />
						<cfelse>
							<cfset script.setRunAt(pluginXML.plugin.scripts.script[i].xmlAttributes.event) />
						</cfif>
						<cfif structKeyExists(pluginXML.plugin.scripts.script[i].xmlAttributes,"component")>
							<cfset script.setScriptFile(pluginXML.plugin.scripts.script[i].xmlAttributes.component) />
						<cfelse>
							<cfset script.setScriptFile(pluginXML.plugin.scripts.script[i].xmlAttributes.scriptfile) />
						</cfif>
						<cfif structKeyExists(pluginXML.plugin.scripts.script[i].xmlAttributes,"cache")>
							<cfset script.setDoCache(pluginXML.plugin.scripts.script[i].xmlAttributes.cache) />
						<cfelse>
							<cfset script.setDoCache("false") />
						</cfif>
						<cfset script.save() />
					</cfloop>
				</cfif>
		</cfif>
	</cfif>
	
	<cfif structKeyExists(pluginXML.plugin,"eventHandlers")>
		<cfif structKeyExists(pluginXML.plugin.eventHandlers,"eventHandler")>
			<cfset eventHandlersLen=arraylen(pluginXML.plugin.eventHandlers.eventHandler)/>
				<cfif eventHandlersLen>
					<cfloop from="1" to="#eventHandlersLen#" index="i">
						<cfset eventHandler=getScriptBean() />
						<cfset eventHandler.setModuleID(modID) />
						<cfif structKeyExists(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes,"event")>
							<cfset eventHandler.setRunAt(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.event) />
						<cfelse>
							<cfset eventHandler.setRunAt(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.runat) />
						</cfif>
						<cfif structKeyExists(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes,"component")>
							<cfset eventHandler.setScriptFile(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.component) />
						<cfelse>
							<cfset eventHandler.setScriptFile(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.scriptfile) />
						</cfif>
						<cfif structKeyExists(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes,"cache")>
							<cfset eventHandler.setDoCache(pluginXML.plugin.eventHandlers.eventHandler[i].xmlAttributes.cache) />
						<cfelse>
							<cfset eventHandler.setDoCache("false") />
						</cfif>
						<cfset eventHandler.save() />
					</cfloop>
				</cfif>
		</cfif>
	</cfif>
	
	<cfif structKeyExists(pluginXML.plugin.displayobjects,"displayobject")>
	<cfset objectsLen=arraylen(pluginXML.plugin.displayobjects.displayobject)/>
		<cfif objectsLen>
			<cfloop from="1" to="#objectsLen#" index="i">
				<cfset displayObject=getDisplayObjectBean() />
				<cfset displayObject.setModuleID(modID) />
				<cfset displayObject.setName(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.name) />
				<cfset displayObject.loadByName() />
				<cfset displayObject.setLocation(pluginXML.plugin.displayobjects.xmlAttributes.location) />
				<cfif structKeyExists(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes,"displayobjectfile")>
					<cfset displayObject.setDisplayObjectFile(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.displayobjectfile) />
				<cfelse>
					<cfset displayObject.setDisplayObjectFile(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.component) />
				</cfif>
				<cfif structKeyExists(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes,"displaymethod")>
					<cfset displayObject.setDisplayMethod(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.displaymethod) />
				<cfelse>
					<cfset displayObject.setDisplayMethod("") />
				</cfif>
				<cfif structKeyExists(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes,"cache")>
					<cfset displayObject.setDoCache(pluginXML.plugin.displayobjects.displayobject[i].xmlAttributes.cache) />
				<cfelse>
					<cfset displayObject.setDoCache("false") />
				</cfif>
				<cfset displayObject.save() />
			</cfloop>
			
		</cfif>
	</cfif>
	
</cffunction>	

<cffunction name="getPlugin" returntype="query" output="false">
<cfargument name="ID">
<cfargument name="cache" required="true" default="true">
	<cfset var rs=""/>
	
	<cfif arguments.cache>
	<cfquery name="rs" dbtype="query">
	select * from variables.rsPlugins where  
	<cfif isNumeric(arguments.ID)>
	pluginID=#arguments.ID#
	<cfelse>
	moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
	</cfif>
	</cfquery>
	<cfelse>
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tplugins where  
	<cfif isNumeric(arguments.ID)>
	pluginID=#arguments.ID#
	<cfelse>
	moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ID#">
	</cfif>
	</cfquery>
	
	</cfif>
	
	<cfreturn rs>
</cffunction>

<cffunction name="getPluginXML" returntype="string" output="false">
<cfargument name="moduleID">
	<cfset var theXML="">
	<cfset var rsPlugin=getPlugin(arguments.moduleID,false)>
	<cfset var delim=variables.configBean.getFileDelim() />
	<cfif fileExists("#getLocation(rsPlugin.pluginID)#plugin#delim#config.xml")>
		<cffile action="read" file="#getLocation(rsPlugin.pluginID)#plugin#delim#config.xml" variable="theXML">
	<cfelse>
		<cffile action="read" file="#getLocation(rsPlugin.pluginID)#plugin#delim#config.xml.cfm" variable="theXML">
	</cfif>
	<cfreturn xmlParse(theXML)/>
</cffunction>

<cffunction name="getAttributeBean" returntype="any" output="false">
<cfargument name="theXML">
<cfargument name="moduleID">
	<cfset var bean=createObject("component","mura.plugin.pluginSettingBean").init(variables.configBean)>
	<cfset bean.set(arguments.theXML,arguments.moduleID)/>
	
	<cfreturn bean/>
</cffunction>

<cffunction name="getConfig" returntype="any" output="false">
<cfargument name="ID">
<cfargument name="cache" required="true" default="true">

	<cfset var pluginConfig=createObject("component","mura.plugin.pluginConfig")>
	<cfset var rs="">
	<cfset var settingStr=structNew()>
	
	<cfset rs=getPlugin(arguments.ID,arguments.cache)>
	
	<cfset pluginConfig.setVersion(rs.version) />
	<cfset pluginConfig.setName(rs.name) />
	<cfset pluginConfig.setProvider(rs.provider) />
	<cfset pluginConfig.setProviderURL(rs.providerURL) />
	<cfset pluginConfig.setPluginID(rs.pluginID) />
	<cfset pluginConfig.setModuleID(rs.moduleID) />
	<cfset pluginConfig.setDeployed(rs.deployed) />
	<cfset pluginConfig.setCategory(rs.category) />
	<cfset pluginConfig.setCreated(rs.created) />
	
	<cfquery name="rs"  dbtype="query">
	select * from variables.rsSettings where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.moduleID#">
	</cfquery>
	
	<cfloop query="rs">
	<cfset settingStr["#rs.name#"]=rs.settingValue />
	</cfloop>
	
	<cfset pluginConfig.initSettings(settingStr)/>
	
	<cfreturn pluginConfig/>
</cffunction>

<cffunction name="getAssignedSites" returntype="query" output="false">
<cfargument name="moduleID">
	<cfset var rs=""/>
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select siteID,moduleID from tcontent where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
	<cfreturn rs>
</cffunction>

<cffunction name="deleteAssignedSites" returntype="void" output="false">
<cfargument name="moduleID">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontent where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="updateSettings" returntype="void" output="false">
<cfargument name="args">

	<cfset var pluginXML=getPluginXML(arguments.args.moduleID) />
	<cfset var settingsLen=0/>
	<cfset var i=1 />
	<cfset var pluginConfig=getConfig(arguments.args.moduleID,false) />
	<cfset var pluginCFC= createObject("component","#variables.configBean.getWebRootMap()#.plugins.#pluginConfig.getPluginID()#.plugin.plugin") />
	<cfset var adminDir="">
	<cfset var siteDir="">
	<cfset var delim=variables.configBean.getFileDelim() >
	<cfset var distroList="" />
	<cfset var dopID=""/>
	<cfset var rsObjects="">
	
	<cfset deleteSettings(arguments.args.moduleID) />
	
	<cfif structKeyExists(pluginXML.plugin.settings,"setting")>
		<cfset settingsLen=arraylen(pluginXML.plugin.settings.setting) />
	</cfif>
	
	<cfif len(settingsLen)>
		<cfloop from="1" to="#settingsLen#" index="i">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into tpluginsettings (moduleID,name,settingValue) values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.settings.setting[i].name.xmlText#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args['#pluginXML.plugin.settings.setting[i].name.xmlText#']#">
			)
			</cfquery>
		</cfloop>
	</cfif>
	
	<cfset deleteScripts(arguments.args.moduleID) />
	
	<cfset savePluginXML(arguments.args.moduleID) />
	
	<cfset deleteAssignedSites(arguments.args.moduleID) />
	
	<cfif structKeyExists(arguments.args,"siteAssignID") and len(arguments.args.siteAssignID)>
		<cfloop list="#arguments.args.siteAssignID#" index="i">
			<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into tcontent (siteID,moduleID,contentID,contentHistID,parentID,type,subType,title,
			display,approved,isNav,active,forceSSL,searchExclude) values (
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">,
			'Plugin',
			'Default',
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#pluginXML.plugin.name.xmlText#">,
			1,
			1,
			1,
			1,
			1,
			1
			)
			</cfquery>
		</cfloop>
	</cfif>
	
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tplugindisplayobjects 
	set location=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.location#">
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">
	</cfquery>
	
	<cfset loadPlugins() />
	

	<cfif arguments.args.location eq "local" and structKeyExists(arguments.args,"siteAssignID") and len(arguments.args.siteAssignID)>
		<cfquery name="rsObjects" dbType="query">
		select * from variables.rsDisplayObjects
		where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">
		</cfquery>
		
		<cfif rsObjects.recordcount>
		<cfloop list="#arguments.args.siteAssignID#" index="i">
			<cfset dopID=variables.settingsManager.getSite(i).getDisplayPoolID()/>
			<cfset siteDir=variables.configBean.getWebRoot() & delim & dopID & delim & "includes" & delim & "plugins" & delim & rsObjects.pluginID & delim>
			<cfset adminDir=variables.configBean.getWebRoot() & delim  & "plugins" & delim & rsObjects.pluginID & delim>
			
			<cfif not listFind(distroList,dopID)>
				
				<cfif isNumeric(rsObjects.pluginID) and arguments.args.overwrite and directoryExists(siteDir)>
					<cfdirectory action="delete" directory="#siteDir#" recurse="true">
				</cfif>
				
				<cfif not directoryExists(siteDir)>			
					<cfset variables.utility.copyDir(adminDir,siteDir)>
				</cfif>
				
				<cfset distroList=listAppend(distroList,dopID)>
			</cfif>
		</cfloop>
		</cfif>
	</cfif>
	
	
	<cfset pluginConfig=getConfig(arguments.args.moduleID) />
	<cfset pluginCFC.init(pluginConfig)>
	
	<cfif pluginConfig.getDeployed() eq 1>
	<cfset pluginCFC.update() />
	<cfelse>
	<cfset pluginCFC.install() />
	</cfif>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tplugins 
	set deployed=1
	where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.args.moduleID#">
	</cfquery>
	
	<cfset loadPlugins() />
</cffunction>

<cffunction name="deleteSettings" returntype="void" output="false">
<cfargument name="moduleID">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tpluginsettings where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="deleteScripts" returntype="void" output="false">
<cfargument name="moduleID">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tpluginscripts where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="deleteDisplayObjects" returntype="void" output="false">
<cfargument name="moduleID">
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentobjects where 
	objectID in (select objectID from tplugindisplayobjects where moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">)
	</cfquery>
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tplugindisplayobjects where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
</cffunction>

<cffunction name="getSitePlugins" returntype="query" output="false">
<cfargument name="siteID">
	<cfset var rs="">
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select tplugins.pluginID,tplugins.moduleID,tplugins.name,tplugins.version,
	tplugins.provider, tplugins.providerURL,tplugins.category,tplugins.created from tplugins inner join tcontent
	on (tplugins.moduleID=tcontent.moduleID and tcontent.siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">)
	</cfquery>
	<cfreturn rs>
</cffunction>

<cffunction name="deletePlugin" returntype="void" output="false">
<cfargument name="moduleID">

	<cfset var rsPlugin=getPlugin(arguments.moduleID) />
	<cfset var location=getLocation(rsPlugin.pluginID) />
	<cfset var pluginConfig=getConfig(arguments.moduleID) />
	<cfset var pluginCFC="/">
	
	<cftry>
	<cfset pluginCFC=createObject("component","#variables.configBean.getWebRootMap()#.plugins.#pluginConfig.getPluginID()#.plugin.plugin") />
	
	<cfset pluginCFC.init(pluginConfig)>
	<cfset pluginCFC.delete() />
	<cfcatch></cfcatch>
	</cftry>

	<cfif isNumeric(rsPlugin.pluginID) and directoryExists(location)>
		<cfdirectory action="delete" directory="#location#" recurse="true">
	</cfif>
	
	<cfset deleteSettings(arguments.moduleID)>
	<cfset deleteAssignedSites(arguments.moduleID)>
	<cfset deleteScripts(arguments.moduleID)>
	<cfset deleteDisplayObjects(arguments.moduleID)>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tplugins where  moduleID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.moduleID#">
	</cfquery>
	
	<cfset loadPlugins() />

</cffunction>

<cffunction name="executeScripts" output="false" returntype="any">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfargument name="event" required="true" default="" type="any">
	<cfset var rs=""/>
	
	<cfset var pluginConfig="">
	<cfset var componentPath="">
	<cfset var scriptPath="">
	<cfset var eventHandler="">
	
	<cfif not isObject(arguments.event)>
		<cfif isStruct(arguments.event)>
			<cfset variables.event=createObject("component","mura.event").init(arguments.event)/>
		<cfelse>				
			<cfif structKeyExists(request,"servletEvent")>
				<cfset arguments.event=request.servletEvent />
			<cfelse>
				<cfset arguments.event=createObject("component","mura.event")/>
			</cfif>
		</cfif>
	</cfif>
	
	<cfset rs=getScripts(arguments.runat,arguments.siteid) />
	
	<cfloop query="rs">
		<cfset event.setValue("siteid",arguments.siteID)>
		
		<cfif listLast(rs.scriptfile,".") neq "cfm">
			<cfset componentPath="plugins.#rs.pluginID#.#rs.scriptfile#">
			<cfset eventHandler=getComponent(componentPath, rs.pluginID, arguments.siteID, rs.docache)>
			<cfinvoke component="#eventHandler#" method="#arguments.runat#">
				<cfinvokeargument name="event" value="#arguments.event#">
			</cfinvoke>	
		<cfelse>
			<cfset pluginConfig=application.pluginManager.getConfig(rs.pluginID)>
			<cfset getExecutor().executeScript(event,"/plugins/#rs.pluginID#/#rs.scriptfile#",pluginConfig)>
		</cfif>
	</cfloop>

</cffunction>

<cffunction name="getScripts" output="false" returntype="query">
<cfargument name="runat">
<cfargument name="siteID" required="true" default="">
<cfset var rs="">

	<cfquery name="rs" dbtype="query">
	select pluginID, scriptfile,name, docache from variables.rsScripts 
	where runat=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.runat#">
	<cfif len(arguments.siteID)>
	and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	</cfif>
	order by pluginID
	</cfquery>
<cfreturn rs/>

</cffunction>

<cffunction name="getDisplayObjectBySiteID" output="false" returntype="query">
<cfargument name="siteID" required="true" default="">

<cfset var rs="">
<cfquery name="rs" dbtype="query">
	select objectID, moduleID, siteID, name, title from variables.rsDisplayObjects 
	where siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	order by moduleID, title, name
</cfquery>

<cfreturn rs/>

</cffunction>

<cffunction name="displayObject" output="true" returntype="any">
<cfargument name="objectID">
<cfargument name="event" required="true" default="">
	
	<cfset var rs=""/>
	<cfset var key=""/>
	<cfset var componentPath=""/>
	<cfset var pluginConfig=""/>
	<cfset var eventHandler=""/>
	<cfset var theDisplay=""/>
	<cfset var site=variables.settingsManager.getSite(arguments.event.getValue('siteID'))/>
	<cfset var cacheFactory=site.getCacheFactory()/>
	
	<cfquery name="rs" dbtype="query">
	select pluginID, displayObjectFile,location,displaymethod, docache, objectID from variables.rsDisplayObjects 
	where objectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.objectID#">
	group by pluginID, displayObjectFile, location, displaymethod, docache, objectID
	</cfquery>
	
	<cfset key= rs.objectID>
	
	<cfif site.getCache() and isBoolean(rs.docache) and rs.docache>
		<cfif NOT cacheFactory.has( key )>
		 	<cftry>
				<cfif listLast(rs.displayobjectfile,".") neq "cfm">
					<cfset componentPath="plugins.#rs.pluginID#.#rs.displayobjectfile#">
					<cfset eventHandler=getComponent(componentPath, rs.pluginID, event.getValue('siteID'),rs.docache)>
					<cfinvoke component="#eventHandler#" method="#rs.displaymethod#" returnVariable="theDisplay">
						<cfinvokeargument name="event" value="#arguments.event#">
					</cfinvoke>	
					<cfreturn cacheFactory.get( key, theDisplay ) />
				<cfelse>
					<cfreturn cacheFactory.get( key, getExecutor().displayObject(arguments.objectID,arguments.event,rs)  ) />
				</cfif>
			<cfcatch>
				 <cfsavecontent variable="theDisplay"><cfdump var="#cfcatch#"></cfsavecontent>
				 <cfreturn theDisplay>
			</cfcatch>
			</cftry>
		<cfelse>
			<cfreturn cacheFactory.get(key)>
		</cfif>
	<cfelse>
		<cftry>
		<cfif listLast(rs.displayobjectfile,".") neq "cfm">
			<cfset componentPath="plugins.#rs.pluginID#.#rs.displayobjectfile#">
			<cfset eventHandler=getComponent(componentPath, rs.pluginID, event.getValue('siteID'),rs.docache)>
			<cfinvoke component="#eventHandler#" method="#rs.displaymethod#" returnVariable="theDisplay">
				<cfinvokeargument name="event" value="#arguments.event#">
			</cfinvoke>	
			<cfreturn theDisplay>
		<cfelse>
			<cfreturn getExecutor().displayObject(arguments.objectID,arguments.event,rs) />
		</cfif>
		<cfcatch>
			 <cfsavecontent variable="theDisplay"><cfdump var="#cfcatch#"></cfsavecontent>
			 <cfreturn theDisplay>
		</cfcatch>
		</cftry>
	</cfif>
		
</cffunction>

<cffunction name="getComponent" returntype="any" output="false">
<cfargument name="componentPath">
<cfargument name="pluginID">
<cfargument name="siteID">
<cfargument name="cache" required="true" default="true">
	
	<cfset var pluginConfig="">
	<cfif isBoolean(arguments.cache) and arguments.cache>
		<cfif NOT getCacheFactory(arguments.siteid).has( componentPath ) or variables.configBean.getMode() eq "development">
			<cfset pluginConfig=application.pluginManager.getConfig(arguments.pluginID)>	
			<cfreturn getCacheFactory(arguments.siteid).get( componentPath, createObject("component",componentPath).init(pluginConfig,configBean) ) />	
		<cfelse>
			<cfreturn getCacheFactory(arguments.siteid).get( componentPath) />
		</cfif>
	<cfelse>
		<cfset pluginConfig=application.pluginManager.getConfig(arguments.pluginID)>
		<cfreturn createObject("component",componentPath).init(pluginConfig,configBean) />
	</cfif>

</cffunction>

<cffunction name="getExecutor" returntype="any" output="false">
<cfset var executor=createObject("component","pluginExecutor").init(variables.configBean,variables.settingsManager,this) />
<cfreturn executor />
</cffunction>

<cffunction name="getDisplayObjectBean" returntype="any" output="false">
<cfreturn createObject("component","pluginDisplayObjectBean").init(variables.configBean) />
</cffunction>

<cffunction name="getScriptBean" returntype="any" output="false">
<cfreturn createObject("component","pluginScriptBean").init(variables.configBean) />
</cffunction>

<cffunction name="purgeEventManagers" returntype="any" output="false">
<cfset variables.eventManagers=structNew()/>
</cffunction>

<cffunction name="getEventManager" returntype="any" output="false">
<cfargument name="siteid" required="true" default="">


	<cfif not structKeyExists(variables.eventManagers,arguments.siteid)>
		<cfset variables.eventManagers[arguments.siteid]=createObject("component","pluginEventManager").init(arguments.siteID,variables.genericManager,this)>
	</cfif>
	
	<cfreturn variables.eventManagers[arguments.siteid]>
</cffunction>

<cffunction name="getCacheFactory" returntype="any" output="false">
<cfargument name="siteid" required="true" default="">


	<cfif not structKeyExists(variables.cacheFactories,arguments.siteid)>
		<cfset variables.cacheFactories[arguments.siteid]=createObject("component","mura.cache.cacheFactory").init()>
	</cfif>
	
	<cfreturn variables.cacheFactories[arguments.siteid]>
</cffunction>

<cffunction name="purgeCacheFactories" returntype="any" output="false">
<cfset variables.cacheFactories=structNew()/>
</cffunction>

<cffunction name="renderAdminTemplate" returntype="any" output="false">
<cfargument name="body">
<cfargument name="pageTitle">
<cfargument name="jsLib" required="true" default="prototype">
<cfargument name="jsLibLoaded" required="true" default="false">
<cfset var fusebox=structNew()>
<cfset var myFusebox=structNew()>
<cfset var returnStr="">
<cfset var moduleTitle=arguments.pageTitle>

<cfset fusebox.layout =arguments.body>
<cfset fusebox.ajax ="">
<cfset myfusebox.originalcircuit="cPlugins">
<cfset myfusebox.originalfuseaction="">
<cfset attributes.moduleID="">
<cfset attributes.jsLib=arguments.jsLib>
<cfset attributes.jsLibLoaded=arguments.jsLibLoaded>
<cfsavecontent variable="returnStr">
<cfinclude template="/#variables.configBean.getWebrootMap()#/admin/view/layouts/template.cfm">
</cfsavecontent>

<cfreturn returnStr/>
</cffunction>

<cffunction name="renderAdminToolbar" returntype="any" output="false">
<cfargument name="jsLib" required="true" default="prototype">
<cfargument name="jsLibLoaded" required="true" default="false">
<cfset var returnStr="">

<cfsavecontent variable="returnStr">
<cfinclude template="/#variables.configBean.getWebrootMap()#/admin/view/layouts/pluginHeader.cfm">
</cfsavecontent>

<cfreturn returnStr/>
</cffunction>

</cfcomponent>