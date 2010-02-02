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
<cfargument name="settingsManager" type="any" required="yes"/>

		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		
<cfreturn this />
</cffunction>

<cffunction name="setUserManager" output="false" returntype="void" access="public">
	<cfargument name="userManager">
	<cfset variables.userManager=arguments.userManager>
</cffunction>

<cffunction name="getBean" access="public" returntype="any">
	<cfreturn createObject("component","mura.user.userBean").init(variables.configBean,variables.settingsManager,variables.userManager)>
</cffunction>

<cffunction name="read" access="public" returntype="any" output="false">
		<cfargument name="userid" type="string" required="yes" />
		<cfset var rsuser = 0 />
		<cfset var rsmembs = "" />
		<cfset var rsInterests = "" />
		<cfset var userBean=getBean() />
			
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" name="rsUser">
			select *
			from tusers 
			where userid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
		</cfquery>
		
		<cfif rsUser.recordCount eq 1>
			<cfset userBean.set(rsUser) />
			<cfset setUserBeanMetaData(userBean)>
			<cfset userBean.setIsNew(0)>
		<cfelse>
			<cfset userBean.setIsNew(1)>
		</cfif>
		
		<cfreturn userBean />
</cffunction>

<cffunction name="readByUsername" access="public" returntype="any" output="false">
		<cfargument name="username" type="string" required="yes" />
		<cfargument name="siteid" type="string" required="yes" />
		<cfset var rsuser = 0 />
		<cfset var rsmembs = "" />
		<cfset var rsInterests = "" />
		<cfset var userBean=application.serviceFactory.getBean("userBean") />
			
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" name="rsUser">
			select *
			from tusers 
			where username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
			and (siteid='#application.settingsManager.getSite(arguments.siteID).getPublicUserPoolID()#'
				or  
				siteid='#application.settingsManager.getSite(arguments.siteID).getPrivateUserPoolID()#'
				) 
		</cfquery>
		
		<cfif rsUser.recordcount gt 1>
			<cfthrow message="The user username '#arguments.username#' that you are reading by is not unique.">
		<cfelseif rsUser.recordCount eq 1>
			<cfset userBean.set(rsUser) />
			<!--- <cfif userBean.getType() eq 2> --->
				<cfset rsmembs=readMemberships(userBean.getUserId()) />
				<cfset rsInterests=readInterestGroups(userBean.getUserId()) />
				<cfset userBean.setGroupId(valuelist(rsmembs.groupid))/>
				<cfset userBean.setCategoryId(valuelist(rsInterests.categoryid))/>
			<!--- </cfif> --->
			<cfset userBean.setAddresses(getAddresses(userBean.getUserID()))/>
			<cfset userBean.setIsNew(0)>
		<cfelse>
			<cfset userBean.setIsNew(1)>
		</cfif>
		
		<cfreturn userBean />
</cffunction>

<cffunction name="readByGroupName" access="public" returntype="any" output="false">
		<cfargument name="groupname" type="string" required="yes" />
		<cfargument name="siteid" type="string" required="yes" />
		<cfargument name="isPublic" type="string" required="yes" default="both"/>
		<cfset var rsuser = 0 />
		<cfset var rsmembs = "" />
		<cfset var rsInterests = "" />
		<cfset var userBean=application.serviceFactory.getBean("userBean") />
			
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" name="rsUser">
			select *
			from tusers 
			where 
			type=1
			and groupname=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupname#">
			and 
			<cfif not isBoolean(arguments.isPublic)>
				(siteid='#application.settingsManager.getSite(arguments.siteID).getPublicUserPoolID()#'
				or  
				siteid='#application.settingsManager.getSite(arguments.siteID).getPrivateUserPoolID()#'
				) 
			<cfelseif arguments.isPublic>
			(siteid='#application.settingsManager.getSite(arguments.siteID).getPublicUserPoolID()#'
				and
			isPublic=1
			) 
			<cfelse>
			(siteid='#application.settingsManager.getSite(arguments.siteID).getPrivateUserPoolID()#'
				and 
			isPublic=0
			) 
			</cfif>
		</cfquery>
		
		<cfif rsUser.recordcount gt 1>
			<cfthrow message="The user groupname '#arguments.groupname#' that you are reading by is not unique.">
		<cfelseif rsUser.recordCount eq 1>
			<cfset userBean.set(rsUser) />
			<!--- <cfif userBean.getType() eq 2> --->
				<cfset rsmembs=readMemberships(userBean.getUserId()) />
				<cfset rsInterests=readInterestGroups(userBean.getUserId()) />
				<cfset userBean.setGroupId(valuelist(rsmembs.groupid))/>
				<cfset userBean.setCategoryId(valuelist(rsInterests.categoryid))/>
			<!--- </cfif> --->
			<cfset userBean.setAddresses(getAddresses(userBean.getUserID()))/>
			<cfset userBean.setIsNew(0)>
		<cfelse>
			<cfset userBean.setIsNew(1)>
		</cfif>
		
		<cfreturn userBean />
</cffunction>

<cffunction name="readByRemoteID" access="public" returntype="any" output="false">
		<cfargument name="remoteid" type="string" required="yes" />
		<cfargument name="siteid" type="string" required="yes" />
		<cfset var rsuser = 0 />
		<cfset var rsmembs = "" />
		<cfset var rsInterests = "" />
		<cfset var userBean=application.serviceFactory.getBean("userBean") />
			
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" name="rsUser">
			select *
			from tusers 
			where remoteid=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.remoteid#">
			and (siteid='#application.settingsManager.getSite(arguments.siteID).getPublicUserPoolID()#'
				or  
				siteid='#application.settingsManager.getSite(arguments.siteID).getPrivateUserPoolID()#'
				) 
		</cfquery>
		
		<cfif rsUser.recordcount gt 1>
			<cfthrow message="The user remoteID '#arguments.remoteID#' that you are reading by is not unique.">
		<cfelseif rsUser.recordCount eq 1>
			<cfset userBean.set(rsUser) />
			<!--- <cfif userBean.getType() eq 2> --->
				<cfset rsmembs=readMemberships(userBean.getUserId()) />
				<cfset rsInterests=readInterestGroups(userBean.getUserId()) />
				<cfset userBean.setGroupId(valuelist(rsmembs.groupid))/>
				<cfset userBean.setCategoryId(valuelist(rsInterests.categoryid))/>
			<!--- </cfif> --->
			<cfset userBean.setAddresses(getAddresses(userBean.getUserID()))/>
			<cfset userBean.setIsNew(0)>
		<cfelse>
			<cfset userBean.setIsNew(1)>
		</cfif>
		
		<cfreturn userBean />
</cffunction>

<cffunction name="create" returntype="void" access="public" output="false">
<cfargument name="userBean" type="any" />

 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
        INSERT INTO tusers  (UserID, RemoteID, s2, Fname, Lname, Password, PasswordCreated,
		Email, GroupName, Type, subType, ContactForm, LastUpdate, lastupdateby, lastupdatebyid,InActive, username,  perm, isPublic,
		company,jobtitle,subscribe,siteid,website,notes,mobilePhone,
		description,interests,photoFileID,keepPrivate,IMName,IMService,created,tags)
     VALUES(
         '#arguments.userBean.getuserid()#',
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getRemoteID() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getRemoteID()#">,
		 #arguments.userBean.gets2()#, 
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getFname() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getFname()#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLname() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLname()#">, 
         <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPassword() neq '',de('no'),de('yes'))#" value="#hash(arguments.userBean.getPassword())#">,
		 #createODBCDateTime(now())#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getEmail() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getEmail()#">,
         <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getGroupName() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getGroupName()#">, 
         #arguments.userBean.getType()#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getSubType() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getSubType()#">, 
        <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.userBean.getContactForm() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getContactForm()#">,
		 #createodbcdatetime(now())#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLastUpdateBy()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLastUpdateById() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLastUpdateByID()#">,
		 #arguments.userBean.getInActive()#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getUsername() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getUsername()#">,
		  #arguments.userBean.getperm()#,
		  #arguments.userBean.getispublic()#,
		   <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getCompany() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getCompany()#">,
		   <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getJobTitle() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getJobTitle()#">, 
		  #arguments.userBean.getsubscribe()#,
		   <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getSiteID()#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getWebsite() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getWebsite()#">,
		 <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.userBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getNotes()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getMobilePhone() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getMobilePhone()#">,
		  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getDescription() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getDescription()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getInterests() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getInterests()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPhotoFileID() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getPhotoFileID()#">,
		#arguments.userBean.getKeepPrivate()#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getIMName() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getIMName()#">,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getIMService() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getIMService()#">,
		 #createODBCDAteTime(now())#,
		 <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getTags() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getTags()#">
		 )
		 
   </CFQUERY>
   
  <!---  <cfif arguments.userBean.getType() eq 2> --->
   <cfset createUserMemberships(arguments.userBean.getUserID(),arguments.userBean.getGroupID()) />
   <cfset clearBadMembeships(arguments.userBean) />
   <cfset createUserInterests(arguments.userBean.getUserID(),arguments.userBean.getCategoryID()) />
   <cfset createTags(arguments.userBean) />
  <!---  </cfif> --->

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void">
		<cfargument name="UserID" type="String" />
		<cfargument name="Type" type="String" />
		<cftransaction>
		
		<!--- <cfswitch expression="#arguments.type#">
		
		<cfcase value="1"> --->
		
			<cfset deleteGroupPermissions(arguments.UserID) />
			<cfset deleteGroupMemberships(arguments.UserID) />
			
		<!--- </cfcase>
		
		<cfcase value="2"> --->
		
			<cfset deleteUserMemberships(arguments.UserID) />
			<cfset deleteUserInterests(arguments.UserID) />
			<cfset deleteUserFavorites(arguments.UserID) />
			<cfset deleteUserRatings(arguments.UserID) />
			<cfset deleteUserAddresses(arguments.UserID) />
			<cfset deleteExtendData(arguments.UserID) />
			<cfset deleteTags(arguments.UserID) />
		
		<!--- </cfcase>
		
	
		
		</cfswitch> --->
		
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		DELETE FROM tusers where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">
		</cfquery>
		
		
		</cftransaction>

</cffunction>

<cffunction name="deleteUserFavorites" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tusersfavorites where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">
	</cfquery>

</cffunction>

<cffunction name="deleteExtendData" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	
	<cfset variables.configBean.getClassExtensionManager().deleteExtendedData(arguments.userID,'tclassextenddatauseractivity')/>
</cffunction>

<cffunction name="deleteUserRatings" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tcontentratings where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">
	</cfquery>

</cffunction>

<cffunction name="update" returntype="void" access="public" output="false">
	<cfargument name="userBean" type="any" />
	<cfargument name="updateGroups" type="boolean" default="true" required="yes" />
	<cfargument name="updateInterests" type="boolean" default="true" required="yes" />
	<cfargument name="OriginID" type="string" default="" required="yes" />
	<cftransaction>


 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      UPDATE tusers SET
		 RemoteID =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getRemoteID() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getRemoteID()#">,
	  	 Fname =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getFname() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getFname()#">,
	  	 Lname =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLname() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLname()#">,
	  	 GroupName =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getGroupname() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getGroupname()#">,  
         Email =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getEmail() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getEmail()#">,
        <cfif arguments.userBean.getPassword() neq ''>
		 Password = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPassword() neq '',de('no'),de('yes'))#" value="#hash(arguments.userBean.getPassword())#">,
		 passwordCreated =#createODBCDateTime(now())#,
		 </cfif>
		 s2 =#arguments.userBean.gets2()#,
         Type = #arguments.userBean.getType()#,
		 subType = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getSubType() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getSubType()#">, 
         ContactForm = <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.userBean.getContactForm() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getContactForm()#">,
		 LastUpdate = #createodbcdatetime(now())#,
		 LastUpdateBy =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLastUpdateBy() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLastUpdateBy()#">,
		 LastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getLastUpdateById() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getLastUpdateById()#">,
		<!---  phone1 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPhone1() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getPhone1()#">,
		 phone2 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPhone2() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getPhone2()#">, --->
		 InActive = #arguments.userBean.getInActive()#,
		 username = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getUsername() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getUsername()#">,
		 isPublic = #arguments.userBean.getispublic()#,
		<!---  address1 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getAddress1() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getAddress1()#">,
		 address2 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getAddress2() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getAddress2()#">,
		 city =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getCity() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getCity()#">,
		 state =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getState() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getState()#">,
		 zip =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getZip() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getZip()#">,
		 fax =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getFax() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getFax()#">, --->
		 company =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getCompany() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getCompany()#">,
		 jobtitle =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getJobTitle() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getJobTitle()#">,
		 website =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getWebsite() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getWebsite()#">,
		 notes =  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.userBean.getNotes() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getNotes()#">,
		 subscribe=#arguments.userBean.getsubscribe()#,
		 siteid = '#trim(arguments.userBean.getSiteID())#',
		 MobilePhone = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getMobilePhone() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getMobilePhone()#">,
		 Description = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getDescription() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getDescription()#">,
		 Interests = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getInterests() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getInterests()#">,
		 PhotoFileID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getPhotoFileID() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getPhotoFileID()#">,
		 keepPrivate = #arguments.userBean.getKeepPrivate()#,
		 IMName = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getIMName() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getIMName()#">,
		 IMService = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getIMService() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getIMService()#">,
		 Tags = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.userBean.getTags() neq '',de('no'),de('yes'))#" value="#arguments.userBean.getTags()#">
		 
       WHERE UserID = '#arguments.userBean.getUserID()#'  
   </CFQUERY>


	<!--- <cfif arguments.userBean.gettype() EQ 2 > --->
		<cfif arguments.updateGroups>
		<cfset deleteUserMemberships(arguments.userBean.getUserID(),arguments.originID) />
		<cfset createUserMemberships(arguments.userBean.getUserID(),arguments.userBean.getGroupID()) />
		<cfset clearBadMembeships(arguments.userBean) />
		</cfif>
		
		<cfif arguments.updateInterests>
		<cfset deleteUserInterests(arguments.userBean.getUserID(),arguments.originID) />
		<cfset createUserInterests(arguments.userBean.getUserID(),arguments.userBean.getCategoryID()) />
		</cfif>
		
		<cfif arguments.userBean.getPrimaryAddressID() neq ''>
		<cfset setPrimaryAddress(arguments.userBean.getUserID(),arguments.userBean.getPrimaryAddressID()) />
		</cfif>
		
		<cfset deleteTags(arguments.userBean.getUserID()) />
		<cfset createTags(arguments.userBean) />
	<!--- </cfif> --->
	
	</cftransaction>

</cffunction>

<cffunction name="deleteUserMemberships" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="originID" type="string" required="yes" default=""/>
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tusersmemb where UserID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userid#">
		<cfif arguments.originID neq "">
			and groupID in (select userID from tusers 
							where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.originID#">
							<!--- and type=1 --->)
		</cfif>
		</cfquery>

</cffunction>

<cffunction name="deleteGroupMemberships" returntype="void" output="false" access="public">
	<cfargument name="groupid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tusersmemb where groupID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupID#">
		</cfquery>

</cffunction>

<cffunction name="deleteGroupPermissions" returntype="void" output="false" access="public">
	<cfargument name="groupid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tpermissions where groupID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupID#">
		</cfquery>

</cffunction>

<cffunction name="deleteUserFromGroup" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="groupid" type="string" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tusersmemb where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"> and groupid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupID#"> 
	</cfquery>

</cffunction>

<cffunction name="createUserInGroup" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="groupid" type="string" />
	<cfset var checkmemb=""/>
	<cftransaction>
	<cfquery name="checkmemb" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tusersmemb where groupid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupID#"> and userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	
	</cfquery>
	
	<cfif not checkmemb.recordcount>
		<cfset createUserMemberships(arguments.UserID,arguments.groupid) />
	</cfif>
	
	</cftransaction>
</cffunction>

<cffunction name="createUserMemberships" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="groupid" type="string" />
	<cfset var I=""/>
	
	<cfloop list="#arguments.groupid#" index="I">
			<cfif I neq "">
			<cftry>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				INSERT INTO tusersmemb (UserID, GroupID)
					VALUES(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#">
					)
				</cfquery>
				<cfcatch></cfcatch>
				</cftry>
			</cfif>
	</cfloop>
		
</cffunction>

<cffunction name="deleteUserInterests" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="originID" type="string" required="yes" default="" />
	
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tusersinterests where UserID='#arguments.UserId#'
		<cfif arguments.originID neq "">
			and categoryID in (select categoryID from tcontentcategories where siteid='#arguments.originID#')
		</cfif>
	</cfquery>

</cffunction>

<cffunction name="createUserInterests" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="categoryid" type="string" />
	<cfset var I=""/>
	
	<cfloop list="#arguments.categoryid#" index="I">
			<cfif I neq "">
			<cftry>
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				INSERT INTO tusersinterests (UserID, categoryID)
					VALUES(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#I#">
					)
				</cfquery>
				<cfcatch></cfcatch>
				</cftry>
			</cfif>
	</cfloop>
		
</cffunction>

<cffunction name="readMemberships" returntype="query" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfset var rs =""/>
	
	<cfquery name="rs"  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Select * from tusers, tusersmemb where tusers.userid=tusersmemb.groupid
	and tusersmemb.userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	order by groupname
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="readGroupMemberships" returntype="query" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfset var rs =""/>
	
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	Select * from tusers, tusersmemb where tusers.userid=tusersmemb.userid and
    tusersmemb.groupid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	<cfif not listFind(session.mura.memberships,'S2')>and tusers.s2 =0</cfif> 
	order by lname</cfquery>
	
	<cfreturn rs />
	</cffunction>
		
<cffunction name="readInterestGroups" returntype="query" access="public" output="false">
	<cfargument name="userid" type="string" default="" />

	<cfset var rs = "" />
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	SELECT categoryID from tusersinterests where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	</cfquery>
	<cfreturn rs />
</cffunction>

<cffunction name="savePassword" returntype="void" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfargument name="password" type="string" />
	
	 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      UPDATE tusers SET
	  	 password =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.password neq '',de('no'),de('yes'))#" value="#hash(arguments.password)#">,
		 passwordCreated =#createODBCDateTime(now())#
       WHERE UserID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"> 
   </CFQUERY>
</cffunction>

<cffunction name="readUserHash" returntype="query" output="false" access="public">
	<cfargument name="userid" type="string" />
	<cfset var rs="">
	 <cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      SELECT userID,password as userHash,siteID,isPublic from tusers
       WHERE UserID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"> 
   </CFQUERY>
	<cfreturn rs/>
</cffunction>
		
<cffunction name="readAddress" access="public" returntype="any" output="false">
		<cfargument name="addressid" type="string" required="yes" />
		<cfset var rs = 0 />
		<cfset var addressBean=application.serviceFactory.getBean("addressBean") />
			
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" name="rsAddress">
			select *
			from tuseraddresses 
			where addressid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressID#"> 
		</cfquery>
		
		<cfif rsAddress.recordCount eq 1>
			<cfset addressBean.set(rsAddress) />
		</cfif>
		
		<cfreturn addressBean />
</cffunction>

<cffunction name="updateAddress" returntype="void" access="public" output="false">
	<cfargument name="addressBean" type="any" />

 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
      UPDATE tuseraddresses SET
		phone =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getPhone() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getPhone()#">,
		address1 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddress1() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddress1()#">,
		address2 =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddress2() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddress2()#">,
		city =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getCity() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getCity()#">,
		state =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getState() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getState()#">,
		zip =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getZip() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getZip()#">,
		fax =  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getFax() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getFax()#">, 
		addressNotes =  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.addressBean.getAddressNotes() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressNotes()#">,
		siteid = '#trim(arguments.addressBean.getSiteID())#',
		UserID = <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getUserID() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getUserID()#">,
		addressName=  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressName() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressName()#">,
		country=  <cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getCountry() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getCountry()#">,
		addressURL=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressURL() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressURL()#">,
		longitude = #arguments.addressBean.getLongitude()#,
		latitude = #arguments.addressBean.getLatitude()#,
		addressEmail=<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressEmail() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressEmail()#">,
		hours =  <cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.addressBean.getHours() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getHours()#">
       WHERE AddressID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressBean.getAddressID()#">
   </CFQUERY>

</cffunction>

<cffunction name="createAddress" returntype="void" access="public" output="false">
<cfargument name="addressBean" type="any" />

 <cfquery  datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
        INSERT INTO tuseraddresses  (AddressID,UserID,siteID,
		phone,fax,address1, address2, city, state, zip ,
		addressName,country,isPrimary,addressNotes,addressURL,
		longitude,latitude,addressEmail,hours)
     VALUES(
        '#arguments.addressBean.getAddressid()#',
		'#arguments.addressBean.getuserid()#',
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getSiteID() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getSiteID()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getPhone() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getPhone()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getFax() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getFax()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddress1() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddress1()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddress2() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddress2()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getCity() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getCity()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getState() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getState()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getZip() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getZip()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressName() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressName()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getCountry() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getCountry()#">,
		#arguments.addressBean.getIsPrimary()#,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.addressBean.getAddressNotes() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressNotes()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressURL() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressURL()#">,
		#arguments.addressBean.getLongitude()#,
		#arguments.addressBean.getLatitude()#,
		<cfqueryparam cfsqltype="cf_sql_varchar" null="#iif(arguments.addressBean.getAddressEmail() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getAddressEmail()#">,
		<cfqueryparam cfsqltype="cf_sql_longvarchar" null="#iif(arguments.addressBean.getHours() neq '',de('no'),de('yes'))#" value="#arguments.addressBean.getHours()#">
		  )
		 
   </CFQUERY>

</cffunction>

<cffunction name="deleteAddress" access="public" output="false" returntype="void">
		<cfargument name="addressID" type="String" />
		
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tuseraddresses where addressID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressID#">
	</cfquery>
	
	<!--- sometimes apps allow addresses to be rated --->
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tcontentratings where contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressID#">
	</cfquery>
	
	<cfset deleteExtendData(arguments.addressID) />
	
</cffunction>

<cffunction name="deleteUserAddresses" access="public" output="false" returntype="void">
		<cfargument name="userID" type="String" />
	
	<cfset var rs=""/>
	<!--- sometimes apps allow addresses to be rated --->
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		DELETE FROM tcontentratings where contentID 
		in (select addressID from tuseraddresses where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">)
	</cfquery>
	
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		select addressID FROM tuseraddresses where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	</cfquery>
	
	<cfloop query="rs">
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
			DELETE FROM tuseraddresses where addressID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.addressID#">
		</cfquery>
		
		<cfset deleteExtendData(rs.addressID) />
	</cfloop>
</cffunction>

<cffunction name="setPrimaryAddress" access="public" output="false" returntype="void">
		<cfargument name="userID" type="String" />
		<cfargument name="addressID" type="String" />
		
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		UPDATE tuseraddresses set isPrimary=0 where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	</cfquery>
	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		UPDATE tuseraddresses set isPrimary=1 where addressID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.addressID#">
	</cfquery>
	
</cffunction>

<cffunction name="getAddresses" access="public" output="false" returntype="query">
		<cfargument name="userID" type="String" />
		<cfset var rs ="" />
	<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
		select * from tuseraddresses where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
		order by isPrimary desc
	</cfquery>
	
	<cfreturn  rs />
</cffunction>

<cffunction name="clearBadMembeships" access="public" output="false" returntype="void">
		<cfargument name="userBean" type="any" />

	<cfif not arguments.userBean.getS2() and  arguments.userBean.getIsPublic()>
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" >
			delete from tusersmemb where userID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userBean.getUserID()#">
			and groupID not in 
			(select userID from tusers 
			where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userBean.getSiteID()#"> 
			and type=1 and isPublic=1
			<!--- and ((isPublic=1 and siteid='#variables.settingsManager.getSite(arguments.userBean.getSiteID()).getPublicUserPoolID()#')
				<cfif not arguments.userBean.getIsPublic()>
				or (isPublic=0 and siteid='#variables.settingsManager.getSite(arguments.userBean.getSiteID()).getPrivateUserPoolID()#')
				</cfif>) --->
			)
		</cfquery>
		
		
	</cfif>
	
</cffunction>

<cffunction name="createTags" access="public" returntype="void" output="false">
	<cfargument name="userBean" type="any" />
	<cfset var taglist  = "" />
	<cfset var t = "" />
		<cfif len(arguments.userBean.getTags())>
			<cfset taglist = arguments.userBean.getTags() />
			<cfloop list="#taglist#" index="t">
				<cfif len(trim(t))>
					<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
					insert into tuserstags (userid,siteid,tag)
					values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userBean.getUserID()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userBean.getSiteID()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(t)#"/>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
</cffunction>

<cffunction name="deleteTags" access="public" returntype="void" output="false">
	<cfargument name="userID"  type="string" />

	<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tuserstags where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	</cfquery>
</cffunction>

<cffunction name="setUserBeanMetaData" output="false" returntype="any">
	<cfargument name="userBean">
	<cfset var rsmembs=readMemberships(userBean.getUserId()) />
	<cfset var rsInterests=readInterestGroups(userBean.getUserId()) />
	<cfset userBean.setGroupId(valuelist(rsmembs.groupid))/>
	<cfset userBean.setCategoryId(valuelist(rsInterests.categoryid))/>
	<cfset userBean.setAddresses(getAddresses(userBean.getUserId()))/>
	
	<cfreturn userBean>
	</cffunction>
</cfcomponent>