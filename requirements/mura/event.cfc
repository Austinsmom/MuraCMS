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
<cfcomponent output="false" extends="mura.cfobject">

<cfset variables.event=structNew() />

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="data"  type="any" default="#structNew()#">
	
	<cfset variables.event=arguments.data />
	
	<cfif len(getValue('siteid')) and application.settingsManager.siteExists(getValue('siteid'))>
		<cfset loadSiteRelatedObjects()/>
	<cfelse>
		<cfset setValue("contentRenderer",application.contentRenderer)>
	</cfif>
	
	<cfif structKeyExists(variables.event,"muraScope")>
		<cfset setValue("MuraScope",createObject("component","mura.MuraScope"))>
		<cfset getValue('MuraScope').setEvent(this)>
		<cfset getValue('MuraScope').setContentRenderer(getValue("contentRenderer"))>
	</cfif>
	
	<cfreturn this />
</cffunction>

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >
	
	<cfset variables.event["#arguments.property#"]=arguments.propertyValue />

</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">
	
	<cfif structKeyExists(variables.event,"#arguments.property#")>
		<cfreturn variables.event["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset variables.event["#arguments.property#"]=arguments.defaultValue />
		<cfreturn variables.event["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="valueExists" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
		<cfreturn structKeyExists(variables.event,arguments.property) />
</cffunction>

<cffunction name="removeValue" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true"/>
		<cfset structDelete(variables.event,arguments.property) />
</cffunction>

<cffunction name="getValues" returntype="any" access="public" output="false">
		<cfreturn variables.event />
</cffunction>

<cffunction name="getAllValues" returntype="any" access="public" output="false">
		<cfreturn variables.event />
</cffunction>

<cffunction name="getHandler" returntype="any" access="public" output="false">
	<cfargument name="handler">
	<cfif isObject(getValue('HandlerFactory'))>
		<cfreturn getValue('HandlerFactory').get(arguments.handler,getValue("localHandler")) />
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
</cffunction>

<cffunction name="getValidator" returntype="any" access="public" output="false">
	<cfargument name="validation">
	
	<cfif isObject(getValue('ValidatorFactory'))>
		<cfreturn getValue('ValidatorFactory').get(arguments.validation,getValue("localHandler")) />	
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
	
</cffunction>

<cffunction name="getTranslator" returntype="any" access="public" output="false">
	<cfargument name="translator">
	
	<cfif isObject(getValue('TranslatorFactory'))>
		<cfreturn getValue('TranslatorFactory').get(arguments.translator,getValue("localHandler")) />	
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>
	
</cffunction>

<cffunction name="getContentRenderer" returntype="any" access="public" output="false">
	<cfreturn getValue('contentRenderer') />	
</cffunction>

<cffunction name="getSite" returntype="any" access="public" output="false">
	<cfif len(getValue('siteid'))>
		<cfreturn application.settingsManager.getSite(getValue('siteid')) />
	<cfelse>
		<cfset throwSiteIDError()>
	</cfif>	
</cffunction>

<cffunction name="getServiceFactory" returntype="any" access="public" output="false">
	<cfreturn application.serviceFactory />	
</cffunction>

<cffunction name="throwSiteIDError" returntype="any" access="public" output="false">
	<cfthrow type="custom" message="The 'SITEID' was not defined for this event">
</cffunction>

<cffunction name="loadSiteRelatedObjects" returntype="any" access="public" output="false">
	<cfif not valueExists("ValidatorFactory")>
		<cfset setValue('ValidatorFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Validator"))>
	</cfif>
	<cfif not valueExists("HandlerFactory")>
		<cfset setValue('HandlerFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Handler"))>
	</cfif>
	<cfif not valueExists("TranslatorFactory")>
		<cfset setValue('TranslatorFactory',application.pluginManager.getEventManager(getValue('siteid')).getFactory("Translator"))>
	</cfif>
	<cfif not valueExists("contentRenderer")>
		<cfset setValue("contentRenderer",createObject("component","#application.settingsManager.getSite(getValue('siteid')).getAssetMap()#.includes.contentRenderer").init(this))>
	</cfif>	
	<cfif not valueExists("localHandler") and fileExists(expandPath("/#application.configBean.getWebRootMap()#") & "/#getValue('siteid')#/includes/eventHandler.cfc")>
		<cfset setValue("localHandler",createObject("component","#application.configBean.getWebRootMap()#.#getValue('siteid')#.includes.eventHandler").init())>
	</cfif>
</cffunction>

</cfcomponent>

