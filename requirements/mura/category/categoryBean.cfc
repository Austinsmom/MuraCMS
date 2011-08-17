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

<cfcomponent extends="mura.bean.bean" output="false">

<cfproperty name="categoryID" type="string" default="" required="true" />
<cfproperty name="siteID" type="string" default="" required="true" />
<cfproperty name="dateCreated" type="date" default="" required="true" />
<cfproperty name="lastUpdate" type="date" default="" required="true" />
<cfproperty name="lastUpdateBy" type="string" default="" required="true" />
<cfproperty name="name" type="string" default="" required="true" />
<cfproperty name="isInterestGroup" type="numeric" default="1" required="true" />
<cfproperty name="parentID" type="string" default="" required="true" />
<cfproperty name="isActive" type="numeric" default="1" required="true" />
<cfproperty name="isOpen" type="numeric" default="1" required="true" />
<cfproperty name="note" type="string" default="" required="true" />
<cfproperty name="sortBy" type="string" default="orderno" required="true" />
<cfproperty name="sortDirection" type="string" default="asc" required="true" />
<cfproperty name="restrictGroups" type="string" default="" required="true" />
<cfproperty name="path" type="string" default="" required="true" />
<cfproperty name="remoteID" type="string" default="" required="true" />
<cfproperty name="remoteSourceURL" type="string" default="" required="true" />
<cfproperty name="remotePubDate" type="date" default="" required="true" />
<cfproperty name="URLtitle" type="string" default="" required="true" />
<cfproperty name="filename" type="string" default="" required="true" />
<cfproperty name="isNew" type="numeric" default="1" required="true" />

<cfset variables.kids = arrayNew(1) />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="categoryManager" type="any" required="yes"/>
	
	<cfset super.init(argumentCollection=arguments)>
	
	<cfset variables.categoryManager=arguments.categoryManager>
	
	<cfset variables.instance.categoryID=""/>
	<cfset variables.instance.siteID=""/>
	<cfset variables.instance.dateCreated="#now()#"/>
	<cfset variables.instance.lastUpdate="#now()#"/>
	<cfset variables.instance.lastUpdateBy=""/>
	<cfset variables.instance.name=""/>
	<cfset variables.instance.isInterestGroup=1 />
	<cfset variables.instance.parentID="" />
	<cfset variables.instance.isActive=1 />
	<cfset variables.instance.isOpen=1 />
	<cfset variables.instance.notes=""/>
	<cfset variables.instance.sortBy = "orderno" />
	<cfset variables.instance.sortDirection = "asc" />
	<cfset variables.instance.RestrictGroups = "" />
	<cfset variables.instance.Path = "" />
	<cfset variables.instance.remoteID = "" />
	<cfset variables.instance.remoteSourceURL = "" />
	<cfset variables.instance.remotePubDate = "">
	<cfset variables.instance.URLTitle = "">
	<cfset variables.instance.filename = "">
	<cfset variables.instance.isNew=1 />

	<cfreturn this />
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="dateCreated" type="String" />
	<cfset variables.instance.dateCreated = parseDateArg(arguments.dateCreated) />
	<cfreturn this>
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfset variables.instance.lastUpdate = parseDateArg(arguments.lastUpdate) />
	<cfreturn this>
</cffunction>

<cffunction name="setlastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
	<cfreturn this>
</cffunction>

<cffunction name="save" returnType="any" output="false" access="public">
	<cfset var kid="">
	<cfset var i="">
	<cfset setAllValues(variables.categoryManager.save(this).getAllValues())>
		
	<cfif arrayLen(variables.kids)>
		<cfloop from="1" to="#arrayLen(variables.kids)#" index="i">
			<cfset kid=variables.kids[i]>
			<cfset kid.save()>
		</cfloop>
	</cfif>
	
	<cfset variables.kids=arrayNew(1)>
	
	<cfreturn this />
</cffunction>
	
<cffunction name="addChild" output="false">
	<cfargument name="child" hint="Instance of a categoryBean">
	<cfset arguments.child.setSiteID(variables.instance.siteID)>
	<cfset arguments.child.setParentID(variables.instance.categoryID)>
	<cfset arrayAppend(variables.kids,arguments.child)>
	<cfreturn this>
</cffunction>
	
<cffunction name="delete" output="false" access="public">
	<cfset variables.categoryManager.delete(variables.instance.categoryID) />
</cffunction>
	
<cffunction name="getKidsQuery" returntype="any" output="false">
	<cfargument name="activeOnly" type="boolean" required="true" default="true">
	<cfargument name="InterestsOnly" type="boolean" required="true" default="false">
		
	<cfreturn variables.categoryManager.getCategories(variables.instance.siteID,variables.instance.categoryID,"", arguments.activeOnly, arguments.InterestsOnly) />
</cffunction>
	
<cffunction name="getKidsIterator" returntype="any" output="false">
	<cfargument name="activeOnly" type="boolean" required="true" default="true">
	<cfargument name="InterestsOnly" type="boolean" required="true" default="false">
	<cfset var it=getServiceFactory().getBean("categoryIterator").init()>
	<cfset it.setQuery(getKidsQuery(arguments.activeOnly, arguments.InterestsOnly))>
	<cfreturn it />
</cffunction>

<cffunction name="loadBy" returnType="any" output="false" access="public">
	<cfset var response="">
	
	<cfif not structKeyExists(arguments,"siteID")>
		<cfset arguments.siteID=variables.instance.siteID>
	</cfif>
	
	<cfset response=variables.categoryManager.read(argumentCollection=arguments)>
	<cfif isArray(response)>
		<cfset setAllValues(response[1].getAllValues())>
		<cfreturn response>
	<cfelse>
		<cfset setAllValues(response.getAllValues())>
		<cfreturn this>
	</cfif>
</cffunction>
	
<cffunction name="setRemotePubDate" output="false" access="public">
    <cfargument name="RemotePubDate" type="string" required="true">
	
	<cfif lsisDate(arguments.RemotePubDate)>
		<cftry>
		<cfset variables.instance.RemotePubDate = lsparseDateTime(arguments.RemotePubDate) />
		<cfcatch>
			<cfset variables.instance.RemotePubDate = arguments.RemotePubDate />
		</cfcatch>
		</cftry>
		<cfelse>
		<cfset variables.instance.RemotePubDate = ""/>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="setURLTitle" output="false" access="public">
	<cfargument name="URLTitle" type="string" required="true">
	
	<cfif arguments.URLTitle neq variables.instance.URLTitle>
  		<cfset variables.instance.URLTitle = getBean("contentUtility").formatFilename(arguments.URLTitle) />
    </cfif>
    <cfreturn this>
</cffunction>
	
<cffunction name="setFilename" output="false" access="public">
    <cfargument name="filename" type="string" required="true">
    <cfset variables.instance.filename = left(trim(arguments.filename),255) />
    <cfreturn this>
</cffunction>
	
<cffunction name="getParent" output="false" returntype="any">
	<cfif len(getParentID())>
		<cfreturn getBean('category').loadBy(categoryID=variables.instance.parentID, siteid=variables.instance.siteID )>
	<cfelse>
		<cfthrow message="Parent category does not exist.">
	</cfif>
</cffunction>
	
<cffunction name="getCrumbQuery" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfreturn variables.categoryManager.getCrumbQuery( variables.instance.path, variables.instance.siteID, arguments.sort) >
</cffunction>
	
<cffunction name="getCrumbIterator" output="false" returntype="any">
	<cfargument name="sort" required="true" default="asc">
	<cfset var rs=getCrumbQuery(arguments.sort)>
	<cfset var it=getBean("categoryIterator").init()>
	<cfset it.setQuery(rs)>
	<cfreturn it>
</cffunction>
	
<cffunction name="getEditUrl" access="public" returntype="string" output="false">
	<cfargument name="compactDisplay" type="any" required="true" default="false"/>
	<cfset var returnStr="">
	
	<cfset returnStr= "#variables.configBean.getContext()#/admin/?fuseaction=cCategory.edit&categoryID=#variables.instance.categoryID#&parentID=#variables.instance.parentID#&siteid=#variables.instance.siteID#&compactDisplay=#arguments.compactdisplay#" >
	
	<cfreturn returnStr>
</cffunction> 

	<cffunction name="hasParent" output="false">
	<cfreturn listLen(variables.instance.path) gt 1>
	</cffunction>
	
	<cffunction name="clone" output="false">
	<cfreturn getBean("category").setAllValues(structCopy(getAllValues()))>
	</cffunction>
</cfcomponent>


