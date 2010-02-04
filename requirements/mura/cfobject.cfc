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
<cfcomponent output="false">
<cfset variables.translator=""/>

<cffunction name="init" returntype="any" access="public" output="false">
	<cfreturn this />
</cffunction>	

<cffunction name="setValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="propertyValue" default="" >

	<cfset variables["#arguments.property#"]=arguments.propertyValue />

</cffunction>

<cffunction name="getValue" returntype="any" access="public" output="false">
<cfargument name="property"  type="string" required="true">
<cfargument name="defaultValue">
	
	<cfif structKeyExists(variables,"#arguments.property#")>
		<cfreturn variables["#arguments.property#"] />
	<cfelseif structKeyExists(arguments,"defaultValue")>
		<cfset variables["#arguments.property#"]=arguments.defaultValue />
		<cfreturn variables["#arguments.property#"] />
	<cfelse>
		<cfreturn "" />
	</cfif>

</cffunction>

<cffunction name="valueExists" returntype="any" access="public" output="false">
	<cfargument name="property" type="string" required="true">
		<cfreturn structKeyExists(variables,arguments.property) />
</cffunction>

<cffunction name="removeValue" returntype="void" access="public" output="false">
	<cfargument name="property" type="string" required="true"/>
		<cfset structDelete(variables,arguments.property) />
</cffunction>

<cffunction name="getConfigBean" returntype="any" access="public" output="false">
	<cfreturn application.configBean />	
</cffunction>
 
<cffunction name="getServiceFactory" returntype="any" access="public" output="false">
	<cfreturn application.serviceFactory />	
</cffunction>

<cffunction name="getBean" returntype="any" access="public" output="false">
	<cfargument name="beanName">
	<cfargument name="siteID" required="false">
	<cfset var bean="">
	
	<cfif application.serviceFactory.containsBean(arguments.beanName)>
		<cfset bean=application.serviceFactory.getBean(arguments.beanName) />
	
		<cfif structKeyExists(bean,"setSiteID")>		
			<cfif structKeyExists(arguments,"siteID") and len(arguments.siteID)>
				<cfset bean.setSiteID(arguments.siteID)>			
			<cfelseif isDefined("getSiteID")>
				<cfset bean.setSiteID(getSiteID())>
			<cfelseif len(getValue("siteID"))>
				<cfset bean.setSiteID(getValue("siteID"))>		
			</cfif>		
		</cfif>
		<cfreturn bean>
	<cfelse>
		<cfthrow message="The requested bean '#arguments.beanName#' is not defined.">
	</cfif>	
</cffunction>

<cffunction name="getPluginManager" returntype="any" access="public" output="false">
	<cfreturn application.pluginManager />	
</cffunction>

<cffunction name="getCurrentUser" returntype="any" access="public" output="false">
	<cfif not structKeyExists(request,"currentUser")>
		<cfset request.currentUser=createObject("component","mura.user.sessionUserFacade").init() />
	</cfif>
	<cfreturn request.currentUser>	
</cffunction>

<cffunction name="getPlugin" returntype="any" access="public" output="false">
	<cfargument name="ID">
	<cfargument name="siteID" required="true" default="">
	<cfargument name="cache" required="true" default="true">
	
	<cfreturn application.pluginManager.getConfig(arguments.ID, arguments.siteID, arguments.cache) />	
</cffunction>

<cffunction name="setTranslator" output="false" returntype="void" access="public">
<cfargument name="translator">
	<cfset variables.translator=arguments.translator/>
	<cfset variables.translator.setBean(this)>
</cffunction>

<cffunction name="translate" output="false" returntype="any" access="public">
<cfargument name="event" required="true" default="">
<cfargument name="translation" required="true" default="">
	<cfset var translation1="">
	<cfset var translation2="">
	<cfif isObject(variables.translator) >
		<cfif len(arguments.translation) and structKeyExists(variables.translator,arguments.translation)>
			<cfsavecontent variable="translation1"><cfinvoke component="#variables.translator#" method="#arguments.translation#" returnVariable="translation2"><cfinvokeargument name="event" value="#arguments.event#"></cfinvoke></cfsavecontent>
			<cfif isDefined("translation2")>
				<cfreturn translation2>
			<cfelse>
				<cfreturn translation1>
			</cfif>
		<cfelseif structKeyExists(variables.translator,"translate")>
			<cfsavecontent variable="translation1"><cfinvoke component="#variables.translator#" method="translate" returnVariable="translation2"><cfinvokeargument name="event" value="#arguments.event#"></cfinvoke></cfsavecontent>
			<cfif isDefined("translation2")>
				<cfreturn translation2>
			<cfelse>
				<cfreturn translation1>
			</cfif>
		<cfelse>
			<cfreturn "translation not implemented">
		</cfif>
	<cfelse>
		<cfreturn getValue(arguments.translation)/>
	</cfif>
</cffunction>

<cffunction name="injectMethod" returntype="void" access="public" output="false">
<cfargument name="toObjectMethod" type="string" required="true" />
<cfargument name="fromObjectMethod" type="any" required="true" />
<cfset this[ arguments.toObjectMethod ] =  arguments.fromObjectMethod  />
<cfset variables[ arguments.toObjectMethod ] =  arguments.fromObjectMethod />
</cffunction>

<cffunction name="deleteMethod" returntype="void" access="public" output="false">
<cfargument name="methodName" type="any" required="true" />
<cfset structKeyDelete(this,arguments.methodName)>
<cfset structKeyDelete(variables,arguments.methodName)>
</cffunction>

</cfcomponent>