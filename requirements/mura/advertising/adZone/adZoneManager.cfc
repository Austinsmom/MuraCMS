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

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="adZoneGateway" type="any" required="yes"/>
<cfargument name="adZoneDAO" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
	<cfset variables.instance.configBean=arguments.configBean />
	<cfset variables.instance.gateway=arguments.adZoneGateway />
	<cfset variables.instance.DAO=arguments.adZoneDAO />
	<cfset variables.instance.globalUtility=arguments.utility />
	<cfreturn this />
</cffunction>

<cffunction name="getadzonesBySiteID" returntype="query" access="public" output="false">
	<cfargument name="siteID"  type="string" />
	<cfargument name="keywords"  type="string" required="true" default=""/>

	<cfreturn variables.instance.gateway.getadzonesBySiteID(arguments.siteid,arguments.keywords) />
</cffunction>

<cffunction name="create" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var adZoneBean=application.serviceFactory.getBean("adZoneBean") />
	<cfset adZoneBean.set(arguments.data) />
	
	<cfif structIsEmpty(adZoneBean.getErrors())>
		<cfset adZoneBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset adZoneBean.setAdZoneID("#createUUID()#") />
		<cfset variables.instance.globalUtility.logEvent("AdZoneID:#adZoneBean.getAdZoneID()# Name:#adZoneBean.getName()# was created","mura-advertising","Information",true) />
		<cfset variables.instance.DAO.create(adZoneBean) />
	</cfif>
	
	<cfreturn adZoneBean />
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
	<cfargument name="adZoneID" type="String" />		
	
	<cfreturn variables.instance.DAO.read(arguments.adZoneID) />

</cffunction>

<cffunction name="update" access="public" returntype="any" output="false">
	<cfargument name="data" type="struct" default="#structnew()#"/>		
	
	<cfset var adZoneBean=variables.instance.DAO.read(arguments.data.adZoneID) />
	<cfset adZoneBean.set(arguments.data) />
	
	<cfif structIsEmpty(adZoneBean.getErrors())>
		<cfset variables.instance.globalUtility.logEvent("AdZoneID:#adZoneBean.getAdZoneID()# Name:#adZoneBean.getName()# was updated","mura-advertising","Information",true) />
		<cfset adZoneBean.setLastUpdateBy("#listGetAt(getAuthUser(),2,'^')#") />
		<cfset variables.instance.DAO.update(adZoneBean) />
	</cfif>
	
	<cfreturn adZoneBean />
</cffunction>

<cffunction name="delete" access="public" returntype="void" output="false">
	<cfargument name="adZoneID" type="String" />		
	
	<cfset var adZoneBean=read(arguments.adZoneID) />
	<cfset variables.instance.globalUtility.logEvent("AdZoneID:#arguments.adZoneID# Name:#adZoneBean.getName()# was created","mura-advertising","Information",true) />
	<cfset variables.instance.DAO.delete(arguments.adZoneID) />

</cffunction>
</cfcomponent>