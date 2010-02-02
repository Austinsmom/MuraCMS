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

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="settingsManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
<cfreturn this />
</cffunction> 

<cffunction name="getUserGroups" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />
	<cfargument name="isPublic" type="numeric" default="0" />
	<cfset var rs = "" />
	
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT tusers.UserID, tusers.Email, tusers.GroupName, tusers.Type, tusers.LastLogin, tusers.LastUpdate, tusers.LastUpdateBy, tusers.LastUpdateByID, Count(tusersmemb.UserID) AS Counter, tusers.Perm, tusers.isPublic
	FROM tusers LEFT JOIN tusersmemb ON tusers.UserID = tusersmemb.GroupID
	WHERE tusers.Type=1 and tusers.isPublic=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isPublic#"> and 
	tusers.siteid = <cfif arguments.isPublic eq 0 >
		'#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
		<cfelse>
		'#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
		</cfif> 
	GROUP BY tusers.UserID, tusers.Email, tusers.GroupName, tusers.Type, tusers.LastLogin, tusers.LastUpdate, tusers.LastUpdateBy, tusers.LastUpdateByID, tusers.perm, tusers.isPublic,tusers.siteid
	Order by tusers.perm desc, tusers.GroupName
	</cfquery>
	
	<cfreturn rs />
</cffunction> 

<cffunction name="getSearch" returntype="query" access="public" output="false">
	<cfargument name="search" type="string" default="" />
	<cfargument name="siteid" type="string" default="" />
	<cfargument name="isPublic" type="numeric" default="0" />
	<cfset var rs = "" />

	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Select * from tusers where type=2 and isPublic = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.isPublic#"> and 
	tusers.siteid = <cfif arguments.isPublic eq 0 >
		'#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
		<cfelse>
		'#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
		</cfif> 
		
	<cfif arguments.search eq ''>
		and 0=1
	</cfif>
	
	 and (
	 		lname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
	 		or fname like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
	 		or company like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
	 		or username like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
	 		or email like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">
	 		or jobtitle like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.search#%">)
	 
	<cfif not listFind(session.mura.memberships,'S2')> and s2=0 </cfif> order by lname
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getAdvancedSearch" returntype="query" access="public" output="false">
	<cfargument name="data" type="any" default="" hint="This can be a struct or an instance of userFeedBean."/>
	<cfargument name="siteid" type="any" hint="deprecated, use userFeedBean.setSiteID()" default=""/>
	<cfargument name="isPublic" type="any" hint="deprecated, use userFeedBean.setIsPublic()" default=""/>
	
	<cfset var i = 1 />
	<cfset var params=""  />
	<cfset var param="" />
	<cfset var paramNum=0 />
	<cfset var started=false />
	<cfset var jointables="" />
	<cfset var jointable="">

	<cfset var rs=""/>

	<cfif not isObject(arguments.data)>
		<cfset params=getServiceFactory().getBean("userFeedBean")>
		<cfset params.setParams(data)>
	<cfelse>
		<cfset params=arguments.data>
	</cfif>
	
	<cfif len(arguments.siteID)>
		<cfset params.setSiteID(arguments.siteID)>
	</cfif>
	
	<cfif isNumeric(arguments.isPublic)>
		<cfset params.setIsPublic(arguments.isPublic)>
	</cfif>
	
	<cfset rsParams=params.getParams() />
	
	<cfloop query="rsParams">
		<cfif listLen(rsParams.field,".") eq 2>
			<cfset jointable=listFirst(rsParams.field,".") >
			<cfif jointable neq "tusers" and not listFind(jointables,jointable)>
				<cfset jointables=listAppend(jointables,jointable)>
			</cfif>
		</cfif>
	</cfloop>

	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" result="request.test">
	Select tusers.* from tusers 
	
	<cfloop list="#jointables#" index="jointable">
	inner join #jointable# on (tusers.userid=#jointable#.userid)
	</cfloop>
	
	where type=2 and isPublic =#params.getIsPublic()# and 
	tusers.siteid = <cfif params.getIsPublic() eq 0 >
		'#variables.settingsManager.getSite(params.getSiteID()).getPrivateUserPoolID()#'
		<cfelse>
		'#variables.settingsManager.getSite(params.getSiteID()).getPublicUserPoolID()#'
		</cfif>
		
		<cfif rsParams.recordcount>
		<cfloop query="rsParams">
			<cfset param=createObject("component","mura.queryParam").init(rsParams.relationship,
					rsParams.field,
					rsParams.dataType,
					rsParams.condition,
					rsParams.criteria
				) />
								 
			<cfif param.getIsValid()>	
				<cfif not started >
					<cfset started = true />and (
				<cfelse>
					<cfif listFindNoCase("openGrouping,(",param.getRelationship())>
						(
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("orOpenGrouping,or (",param.getRelationship())>
						or (
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("andOpenGrouping,and (",param.getRelationship())>
						and (
						<cfset openGrouping=true />
					<cfelseif listFindNoCase("closeGrouping,)",param.getRelationship())>
						)
					<cfelse>
						<cfif not openGrouping>
						#param.getRelationship()#
						<cfelse>
						<cfset openGrouping=false />
						</cfif>
					</cfif>
				</cfif>
				<cfif  listLen(param.getField(),".") gt 1>			
					#param.getField()# #param.getCondition()# <cfif param.getCondition() eq "IN">(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(param.getCondition() eq 'IN',de('true'),de('false'))#"><cfif param.getCondition() eq "IN">)</cfif>  	
				<cfelseif len(param.getField())>
					tusers.userID IN (
											select baseID from tclassextenddatauseractivity
											<cfif isNumeric(param.getField())>
											where tclassextenddatauseractivity.attributeID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
											<cfelse>
											inner join tclassextendattributes on (tclassextenddata.attributeID = tclassextendattributes.attributeID)
											where tclassextendattributes.siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.feedBean.getSiteID()#">
											and tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#param.getField()#">
											</cfif>
											and tclassextenddatauseractivity.attributeValue #param.getCondition()# <cfif param.getCondition() eq "IN">(</cfif><cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#" list="#iif(param.getCondition() eq 'IN',de('true'),de('false'))#"><cfif param.getCondition() eq "IN">)</cfif>)
				</cfif>
			</cfif>						
		</cfloop>
		<cfif started>)</cfif>
	</cfif> 
	<!---
	<cfif arrayLen(paramArray)>
		<cfloop from="1" to="#arrayLen(paramArray)#" index="i">
				<cfset param=paramArray[i] />
		 		<cfif not started ><cfset started = true />and (<cfelse>#param.getRelationship()#</cfif>			
		 		#param.getField()# #param.getCondition()# <cfqueryparam cfsqltype="cf_sql_#param.getDataType()#" value="#param.getCriteria()#">  	
		</cfloop>
		<cfif started>)</cfif>
	</cfif>
	--->
	
  	<cfif len(params.getCategoryID())>
	<cfset paramNum=listLen(params.getCategoryID())>
	and tusers.userID in (select userID from tusersinterests
							where categoryID in 
							(<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(params.getCategoryID())#">
							<cfif paramNum gt 1>
							<cfloop from="2" to="#paramNum#" index="i">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(params.getCategoryID(),i)#">
							</cfloop>
							</cfif>
							)
							)
	</cfif>
	
	<cfif len(params.getGroupID())>
	<cfset paramNum=listLen(params.getGroupID())>
	and tusers.userID in (select userID from tusersmemb
							where groupID in 
							(<cfqueryparam cfsqltype="cf_sql_varchar" value="#listFirst(params.getGroupID())#">
							<cfif paramNum gt 1>
							<cfloop from="2" to="#paramNum#" index="i">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAt(params.getGroupID(),i)#">
							</cfloop>
							</cfif>
							)
							)
	</cfif>
	
	
	
	and inactive=#params.getInActive()#
	
	
	<cfif not listFind(session.mura.memberships,'S2')> and s2=0 </cfif> order by lname
 
	</cfquery>
	
	<cfreturn rs />
</cffunction>

<cffunction name="getPrivateGroups" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />
	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT tsettings.Site, tusers.UserID, tusers.GroupName
	FROM tsettings INNER JOIN tusers ON tsettings.SiteID = tusers.SiteID
	WHERE tusers.Type=1 AND tusers.isPublic=0
	and tusers.siteID = '#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
	ORDER BY tsettings.Site, tusers.Perm DESC, tusers.GroupName
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="getPublicGroups" returntype="query" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />
	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT tsettings.Site, tusers.UserID, tusers.GroupName
	FROM tsettings INNER JOIN tusers ON tsettings.SiteID = tusers.SiteID
	WHERE tusers.Type=1 AND tusers.isPublic=1
	and tsettings.PublicUserPoolID = '#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
	ORDER BY tsettings.Site, tusers.Perm DESC, tusers.GroupName
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="getCreatedMembers" returntype="numeric" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />
	<cfargument name="startDate" type="string" required="true" default="">
	<cfargument name="stopDate" type="string" required="true" default="">
	
	<cfset var rs = "" />
	<cfset var start = "" />
	<cfset var stop = "" />
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT Count(*) as theCount
	FROM tusers
	WHERE tusers.Type=2 AND tusers.isPublic=1
	and siteID = '#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
	<cfif lsisdate(arguments.stopDate)>
		<cfset stop=lsParseDateTime(arguments.stopDate)/>
		and created <=  #createODBCDateTime(createDateTime(year(stop),month(stop),day(stop),23,59,0))#</cfif>
	<cfif lsisdate(arguments.startDate)>
		<cfset start=lsParseDateTime(arguments.startDate)/>
		and created >=  #createODBCDateTime(createDateTime(year(start),month(start),day(start),0,0,0))#</cfif>
	</cfquery>
	<cfreturn rs.theCount />
</cffunction>

<cffunction name="getTotalMembers" returntype="numeric" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />

	
	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT Count(*) as theCount
	FROM tusers
	WHERE tusers.Type=2 AND tusers.isPublic=1
	and siteID = '#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#'
	and inActive=0
	
	</cfquery>
	<cfreturn rs.theCount />
</cffunction>

<cffunction name="getTotalAdministrators" returntype="numeric" access="public" output="false">
	<cfargument name="siteid" type="string" default="" />

	
	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT Count(*) as theCount
	FROM tusers
	WHERE tusers.Type=2 AND tusers.isPublic=0
	and siteID = '#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#'
	and inActive=0
	
	</cfquery>
	<cfreturn rs.theCount />
</cffunction>

</cfcomponent>