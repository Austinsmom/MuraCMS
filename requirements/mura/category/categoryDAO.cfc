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

<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.dsn=variables.configBean.getDatasource()/>
	<cfreturn this />
</cffunction>

<cffunction name="getBean" access="public" returntype="any">
	<cfreturn createObject("component","mura.category.categoryBean").init()>
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
	<cfargument name="categoryBean" type="any" />
	 
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	insert into tcontentcategories (categoryID,siteid,parentID,dateCreated,lastupdate,lastupdateBy,
	name,notes,isInterestGroup,isActive,isOpen,sortBy,sortDirection,restrictgroups,path)
	values (
	'#arguments.categoryBean.getCategoryID()#',
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getsiteID()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getParentID() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getParentID()#">,
	<cfif isDate(arguments.categoryBean.getDateCreated()) >#createODBCDateTime(arguments.categoryBean.getDateCreated())#<cfelse>null</cfif>,
	<cfif isDate(arguments.categoryBean.getLastUpdate()) >#createODBCDateTime(arguments.categoryBean.getLastUpdate())#<cfelse>null</cfif>,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getLastUpdateBy()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getName()#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.categoryBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getNotes()#">,
	#arguments.categoryBean.getIsInterestGroup()#,
	#arguments.categoryBean.getIsActive()#,
	#arguments.categoryBean.getIsOpen()#,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getSortBy() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getSortBy()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getSortDirection() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getSortDirection()#">,
	<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getRestrictGroups() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getRestrictGroups()#">,
	<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.categoryBean.getPath() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getPath()#">)
	</cfquery>

</cffunction> 

<cffunction name="read" access="public" output="false" returntype="any" >
	<cfargument name="categoryID" type="string" />

	<cfset var categoryBean=getBean() />
	<cfset var rs ="" />
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Select * from tcontentcategories where 
	categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />
	</cfquery>
	
	<cfif rs.recordcount>
	<cfset categoryBean.set(rs) />
	</cfif>
	
	<cfreturn categoryBean />
</cffunction>

<cffunction name="keepCategories" returntype="void" access="public" output="false">
	<cfargument name="contentHistID" type="string" default=""/>
	<cfargument name="rsKeepers" type="query"/>
			
	<cfloop query="arguments.rsKeepers">
		
		<cfset saveAssignment(arguments.contentHistID, rsKeepers.contentID, rsKeepers.categoryID, rsKeepers.siteID,
				rsKeepers.orderno, rsKeepers.isFeature, rsKeepers.featureStart, rsKeepers.featureStop)>
	</cfloop>

</cffunction>

<cffunction name="saveAssignment" returntype="void" access="public" output="false">
	<cfargument name="contentHistID" type="string" default=""/>
	<cfargument name="contentID" />
	<cfargument name="categoryID" />
	<cfargument name="siteID" />
	<cfargument name="orderNo" required="true" default="0"/>
	<cfargument name="isFeature"  required="true" default="0"/>	
	<cfargument name="featureStart"  required="true" default=""/>	
	<cfargument name="featureStop"  required="true" default=""/>		
	
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert Into tcontentcategoryassign (categoryID,contentID,contentHistID,isFeature,orderno,siteid,
		featureStart,featureStop)
		values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentHistID#" />,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isFeature#" />,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.orderno#" />,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />,
		<cfif arguments.isFeature eq 2 and isdate(arguments.featureStart)> #createodbcdatetime(arguments.featurestart)#<cfelse>null</cfif>,
		<cfif arguments.isFeature eq 2 and isdate(arguments.featureStop)> #createodbcdatetime(arguments.featureStop)#<cfelse>null</cfif>)
		</cfquery>
	

</cffunction>

<cffunction name="update" access="public" output="false" returntype="void" >
	<cfargument name="categoryBean" type="any" />
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontentcategories set
	lastUpdate = <cfif isDate(arguments.categoryBean.getLastUpdate()) >#createODBCDateTime(arguments.categoryBean.getLastUpdate())#<cfelse>null</cfif>,
	lastupdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getLastUpdateBy()#">,
	name = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getName() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getName()#">,
	isActive = #arguments.categoryBean.getIsActive()#,
	isOpen = #arguments.categoryBean.getIsOpen()#,
	parentID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getParentID() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getParentID()#">,
	isInterestGroup = #arguments.categoryBean.getIsInterestGroup()#,
	notes= <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.categoryBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getNotes()#">,
	sortBy = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getSortBy() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getSortBy()#">,
	sortDirection = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getSortDirection() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getSortDirection()#">,
	restrictGroups = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.categoryBean.getRestrictGroups() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getRestrictGroups()#">,
	path= <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.categoryBean.getPath() neq '',de('no'),de('yes'))#" value="#arguments.categoryBean.getPath()#">
	where categoryID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryBean.getCategoryID()#" />
	</cfquery>

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void" >
	<cfargument name="categoryID" type="String" />
	
	<cfset var categoryBean=read(arguments.categoryID) />
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontentcategories set 
	parentID=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(categoryBean.getParentID() neq '',de('no'),de('yes'))#" value="#categoryBean.getParentID()#">
	where parentID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />
	</cfquery>
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentcategories 
	where categoryID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />
	</cfquery>
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tcontentcategoryassign 
	where categoryID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />
	</cfquery>

</cffunction>

<cffunction name="setListOrder" returntype="void" access="public" output="false">
	<cfargument name="categoryID" type="string" default=""/>
	<cfargument name="orderid" type="string" default=""/>
	<cfargument name="orderno" type="string" default=""/>
	<cfargument name="siteid" type="string" default=""/>
	
	<cfset var i=0 />

	<cfloop from="1" to="#listlen(arguments.orderid)#" index="i">
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tcontentcategoryassign set 
	orderno=<cfqueryparam cfsqltype="cf_sql_numeric" value="#listgetat(arguments.orderno,i)#" />
	where contentID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.orderid,i)#" />
	and categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" />
	and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>
	</cfloop>

</cffunction>

<cffunction name="getCurrentOrderNo" returntype="numeric" access="public" output="false">
	<cfargument name="categoryID" type="string" default=""/>
	<cfargument name="contentID" type="string" default=""/>
	<cfargument name="siteID" type="string" default=""/>
	
	<cfset var rs = ""/>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select distinct tcontentcategoryassign.orderno from tcontentcategoryassign  inner join tcontent
	ON (tcontentcategoryassign.contentid=tcontent.contentid
		and tcontentcategoryassign.siteid=tcontent.siteid)
	where tcontent.contentID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" /> and 		
	categoryID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" /> 
	and tcontent.siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	and tcontent.active=1
	</cfquery>

	<cfif rs.recordcount>
		<cfreturn rs.orderno/>
	<cfelse>
		<cfreturn 0/>
	</cfif>
</cffunction>

<cffunction name="setAssignment" returntype="void" access="public" output="false">
	<cfargument name="categoryID" type="string" default=""/>
	<cfargument name="contentID" type="string" default=""/>
	<cfargument name="contentHistID" type="string" default=""/>
	<cfargument name="isFeature" type="numeric" default="0"/>
	<cfargument name="orderno" type="numeric" default="0"/>
	<cfargument name="siteID" type="string" default=""/>
	<cfargument name="schedule" type="struct" default="#structNew()#"/>
	
	<cfset var feature = arguments.isFeature />
	<cfset var sched = arguments.schedule />
	
	<cfif feature eq 2 AND isDate(sched.featureStart)>
		<cfif sched.startdaypart eq "PM">
			<cfset sched.starthour = sched.starthour + 12>
			
			<cfif sched.starthour eq 24>
				<cfset sched.starthour = 12>
			</cfif>
		<cfelse>
			<cfif sched.starthour eq 12>
				<cfset sched.starthour = 0>
			</cfif>
		</cfif>
		
		<cfset sched.featureStart = createDateTime(year(sched.featureStart), month(sched.featureStart), day(sched.featureStart),sched.starthour, sched.startMinute, "0")>
	<cfelseif feature eq 2>
		<cfset feature = 1 />
	</cfif>
	
	<cfif feature eq 2 AND isDate(sched.featurestop)>
		<cfif sched.stopdaypart eq "PM">
			<cfset sched.stophour = sched.stophour + 12>
			
			<cfif sched.stophour eq 24>
				<cfset sched.stophour = 12>
			</cfif>
		<cfelse>
			<cfif sched.stophour eq 12>
				<cfset sched.stophour = 0>
			</cfif>
		</cfif>
		
		<cfset sched.featurestop = createDateTime(year(sched.featurestop), month(sched.featurestop), day(sched.featurestop),sched.stophour, sched.stopMinute, "0")>
	</cfif>
	
	<cfset saveAssignment(arguments.contentHistID, arguments.contentID, arguments.categoryID, arguments.siteID,
				arguments.orderno, feature, sched.featureStart, sched.featureStop)>

</cffunction>

<cffunction name="pushCategory" returntype="void" access="public" output="false">
	<cfargument name="categoryID" type="string" default=""/>
	<cfargument name="siteID" type="string" default=""/>
	
	<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontentcategoryassign set orderno=OrderNo+1 where 
		categoryid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#" /> and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#" />
	</cfquery>

</cffunction>

</cfcomponent>