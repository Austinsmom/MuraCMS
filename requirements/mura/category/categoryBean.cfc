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
<cfset variables.categoryManager = "" />
<cfset variables.instance.errors=structnew() />

<cffunction name="init" returntype="any" output="false" access="public">
	<cfargument name="categoryManager" type="any" required="yes"/>
	<cfset variables.categoryManager=arguments.categoryManager>
	<cfreturn this />
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="category" type="any" required="true">

		<cfset var prop="" />
		
		<cfif isquery(arguments.category)>
		
			<cfset setcategoryID(arguments.category.categoryID) />
			<cfset setsiteID(arguments.category.siteID) />
			<cfset setdateCreated(arguments.category.dateCreated) />
			<cfset setlastUpdate(arguments.category.lastUpdate) />
			<cfset setlastUpdateby(arguments.category.lastUpdateBy) />
			<cfset setname(arguments.category.name) />
			<cfset setIsInterestGroup(arguments.category.isInterestGroup)/>
			<cfset setParentID(arguments.category.parentID) />
			<cfset setisActive(arguments.category.isActive)/>
			<cfset setisOpen(arguments.category.isOpen)/>
			<cfset setnotes(arguments.category.notes) />
			<cfset setSortBy(arguments.category.sortBy) />
			<cfset setSortDirection(arguments.category.sortDirection) />
			<cfset setRestrictGroups(arguments.category.RestrictGroups) />
			<cfset setPath(arguments.category.Path) />
	
			
		<cfelseif isStruct(arguments.category)>
		
			<cfloop collection="#arguments.category#" item="prop">
				<cfif isdefined("variables.instance.#prop#")>
					<cfset evaluate("set#prop#(arguments.category[prop])") />
				</cfif>
			</cfloop>
			
		</cfif>
		
		<cfset validate() />
		
</cffunction>
 
<cffunction name="setAllValues" returntype="any" access="public" output="false">
	<cfargument name="instance">
	<cfset variables.instance=arguments.instance/>
</cffunction>

<cffunction name="getAllValues" access="public" output="false" returntype="struct">
	<cfreturn variables.instance  />
</cffunction>

<cffunction name="validate" access="public" output="false" returntype="void">
	<cfset variables.instance.errors=structnew() />
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
    <cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getCategoryID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.categoryID />
</cffunction>

<cffunction name="setCategoryID" returntype="void" access="public" output="false">
	<cfargument name="categoryID" type="String" />
	<cfset variables.instance.categoryID = trim(arguments.categoryID) />
</cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="siteID" type="String" />
	<cfset variables.instance.siteID = trim(arguments.siteID) />
</cffunction>

<cffunction name="getDateCreated" returntype="String" access="public" output="false">
	<cfreturn variables.instance.dateCreated />
</cffunction>

<cffunction name="setDateCreated" access="public" output="false">
	<cfargument name="dateCreated" type="String" />
	<cfif isDate(arguments.dateCreated)>
	<cfset variables.instance.dateCreated = parseDateTime(arguments.dateCreated) />
	<cfelse>
	<cfset variables.instance.dateCreated = ""/>
	</cfif>
</cffunction>

<cffunction name="getLastUpdate" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdate />
</cffunction>

<cffunction name="setLastUpdate" access="public" output="false">
	<cfargument name="lastUpdate" type="String" />
	<cfif isDate(arguments.lastUpdate)>
	<cfset variables.instance.lastUpdate = parseDateTime(arguments.lastUpdate) />
	<cfelse>
	<cfset variables.instance.lastUpdate = ""/>
	</cfif>
</cffunction>

<cffunction name="getlastUpdateBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.lastUpdateBy />
</cffunction>

<cffunction name="setlastUpdateBy" access="public" output="false">
	<cfargument name="lastUpdateBy" type="String" />
	<cfset variables.instance.lastUpdateBy = left(trim(arguments.lastUpdateBy),50) />
</cffunction>

<cffunction name="getName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.name />
</cffunction>

<cffunction name="setName" access="public" output="false">
	<cfargument name="name" type="String" />
	<cfset variables.instance.name = trim(arguments.name) />
</cffunction>

<cffunction name="getIsInterestGroup" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isInterestGroup />
</cffunction>

<cffunction name="setIsInterestGroup" access="public" output="false">
	<cfargument name="isInterestGroup" type="numeric" />
	<cfset variables.instance.isInterestGroup = arguments.isInterestGroup />
</cffunction>

<cffunction name="getParentID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.parentID />
</cffunction>

<cffunction name="setParentID" access="public" output="false">
	<cfargument name="ParentID" type="String" />
	<cfset variables.instance.ParentID = trim(arguments.ParentID) />
</cffunction>

<cffunction name="getIsActive" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isActive />
</cffunction>

<cffunction name="setIsActive" access="public" output="false">
	<cfargument name="isActive" type="numeric" />
	<cfset variables.instance.isActive = arguments.isActive />
</cffunction>

<cffunction name="getIsOpen" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.isOpen />
</cffunction>

<cffunction name="setIsOpen" access="public" output="false">
	<cfargument name="isOpen" type="numeric" />
	<cfset variables.instance.isOpen = arguments.isOpen />
</cffunction>

<cffunction name="getNotes" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Notes />
</cffunction>

<cffunction name="setNotes" access="public" output="false">
	<cfargument name="Notes" type="String" />
	<cfset variables.instance.Notes = trim(arguments.Notes) />
</cffunction>

 <cffunction name="setSortBy" returnType="void" output="false" access="public">
    <cfargument name="SortBy" type="string" required="true">
    <cfset variables.instance.SortBy = trim(arguments.SortBy) />
  </cffunction>

  <cffunction name="getSortBy" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SortBy />
  </cffunction>
  
   <cffunction name="setSortDirection" returnType="void" output="false" access="public">
    <cfargument name="SortDirection" type="string" required="true">
    <cfset variables.instance.SortDirection = trim(arguments.SortDirection) />
  </cffunction>

  <cffunction name="getSortDirection" returnType="string" output="false" access="public">
    <cfreturn variables.instance.SortDirection />
  </cffunction>
  
    <cffunction name="setRestrictGroups" returnType="void" output="false" access="public">
    <cfargument name="RestrictGroups" type="string" required="true">
    <cfset variables.instance.RestrictGroups = trim(arguments.RestrictGroups) />
  </cffunction>

  <cffunction name="getRestrictGroups" returnType="string" output="false" access="public">
    <cfreturn variables.instance.RestrictGroups />
  </cffunction>
  
    <cffunction name="setPath" returnType="void" output="false" access="public">
    <cfargument name="Path" type="string" required="true">
    <cfset variables.instance.Path = trim(arguments.Path) />
  </cffunction>

  <cffunction name="getPath" returnType="string" output="false" access="public">
    <cfreturn variables.instance.Path />
  </cffunction>

	<cffunction name="save" returnType="any" output="false" access="public">
		<cfreturn variables.categoryManager.save(this) />
	</cffunction>
	
	<cffunction name="delete" returnType="void" output="false" access="public">
		<cfset variables.categoryManager.delete(getCategoryID()) />
	</cffunction>
	
	<cffunction name="getKidsQuery" returntype="any" output="false">
		<cfreturn variables.categoryManager.getCategories(getSiteID(),getCategoryID()) />
	</cffunction>
	
	<cffunction name="getKidsIterator" returntype="any" output="false">
		<cfset var it=getServiceFactory().getBean("categoryIterator").init()>
		<cfset it.setQuery(getKidsQuery())>
		<cfreturn it />
	</cffunction>

</cfcomponent>


