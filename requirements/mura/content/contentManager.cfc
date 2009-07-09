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

	<cffunction name="init" access="public" returntype="any" output="false">
		<cfargument name="contentGateway" type="any" required="yes"/>
		<cfargument name="contentDAO" type="any" required="yes"/>
		<cfargument name="contentUtility" type="any" required="yes"/>
		<cfargument name="reminderManager" type="any" required="yes"/>
		<cfargument name="settingsManager" type="any" required="yes"/>
		<cfargument name="utility" type="any" required="yes"/>
		<cfargument name="categoryManager" type="any" required="yes"/>
		<cfargument name="configBean" type="any" required="yes"/>
		<cfargument name="fileManager" type="any" required="yes"/>
		<cfargument name="pluginManager" type="any" required="yes"/>
		
		<cfset variables.contentGateway=arguments.contentGateway />
		<cfset variables.contentDAO=arguments.contentDAO />
		<cfset variables.contentUtility=arguments.contentUtility />
		<cfset variables.reminderManager=arguments.reminderManager />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.utility=arguments.utility />
		<cfset variables.categoryManager=arguments.categoryManager />
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.fileManager=arguments.fileManager />
		<cfset variables.pluginManager=arguments.pluginManager />
		<cfset variables.ClassExtensionManager=variables.configBean.getClassExtensionManager() />
		
		<cfreturn this />
	</cffunction>

	<cffunction name="getList" access="public" returntype="query" output="false">
		<cfargument name="args" type="struct"/>
		<cfset var rs ="" />
		<cfset var data=arguments.args />
		
		<cfparam name="data.topid" default="00000000000000000000000000000000001" />
		<cfparam name="data.sortBy" default="orderno">
		<cfparam name="data.sortDirection" default="asc">
		<cfparam name="data.searchString" default="">
		
		<cfswitch expression="#data.moduleid#">
			<cfcase value="00000000000000000000000000000000003,00000000000000000000000000000000004,00000000000000000000000000000000011,00000000000000000000000000000000012,00000000000000000000000000000000013" delimiters=",">
				<cfset rs=variables.contentGateway.getNest(data.topid,data.siteid,data.sortBy,data.sortDirection,data.searchString) />
			</cfcase>
			<cfdefaultcase>
				<cfset rs=variables.contentGateway.getTop(data.topid,data.siteid) />
			</cfdefaultcase>
		</cfswitch>
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getNest" access="public" returntype="query" output="false">
		<cfargument name="parentid" type="string"/>
		<cfargument name="siteid" type="string"/>
		<cfargument name="sortBy" type="string" required="yes" default="orderno" />
		<cfargument name="sortDirection" type="string" required="yes" default="asc" />
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getNest(arguments.parentid,arguments.siteid,arguments.sortBy,arguments.sortDirection) />
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getHist" access="public" returntype="query" output="false">
		<cfargument name="contentid" type="string"/>
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getHist(arguments.contentid,arguments.siteid) />
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getDraftHist" access="public" returntype="query" output="false">
		<cfargument name="contentid" type="string"/>
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getDraftHist(arguments.contentid,arguments.siteid) />
		
		<cfreturn rs />
	</cffunction>

	<cffunction name="getArchiveHist" access="public" returntype="query" output="false">
		<cfargument name="contentid" type="string"/>
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getArchiveHist(arguments.contentid,arguments.siteid) />
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getItemCount" access="public" returntype="query" output="false">
		<cfargument name="contentid" type="string"/>
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getItemCount(arguments.contentid,arguments.siteid) />
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getDraftList" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getDraftList(arguments.siteid) />
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getcontentVersion" access="public" returntype="any" output="false">
		<cfargument name="contentHistID" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		
		<cfreturn variables.contentDAO.readVersion(arguments.contentHistID,arguments.siteid,arguments.use404) />
	</cffunction>
	
	<cffunction name="getActiveContentByFilename" access="public" returntype="any" output="false">
		<cfargument name="filename" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		
		<cfset var key=arguments.siteid & arguments.filename />
		<cfset var site=variables.settingsManager.getSite(arguments.siteid)/>
		<cfset var cacheFactory=site.getCacheFactory()>
		<cfset var contentBean="">
		
		<cfif site.getCache()>
			<!--- check to see if it is cached. if not then pass in the context --->
			<!--- otherwise grab it from the cache --->
			<cfif NOT cacheFactory.has( key )>
				<cfset contentBean=variables.contentDAO.readActiveByFilename(arguments.filename,arguments.siteid,arguments.use404) />
				<cfset cacheFactory.get( key, contentBean.getAllValues() ) />
				<cfreturn contentBean/>
			<cfelse>
				<cfset contentBean=variables.contentDAO.getBean()/>
				<cfset contentBean.setAllValues(cacheFactory.get( key ))>
				<cfreturn contentBean />
			</cfif>
		<cfelse>
			<cfreturn variables.contentDAO.readActiveByFilename(arguments.filename,arguments.siteid,arguments.use404)/>
		</cfif>
	
	</cffunction>
	
	<cffunction name="getActiveByRemoteID" access="public" returntype="any" output="false">
		<cfargument name="remoteID" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		
		<cfset var key="remote" & arguments.siteid & arguments.remoteID />
		<cfset var site=variables.settingsManager.getSite(arguments.siteid)/>
		<cfset var cacheFactory=site.getCacheFactory()/>
		<cfset var contentBean=""/>
		
		<cfif site.getCache()>
			<!--- check to see if it is cached. if not then pass in the context --->
			<!--- otherwise grab it from the cache --->
			<cfif NOT cacheFactory.has( key )>
				<cfset contentBean=variables.contentDAO.readActiveByRemoteID(arguments.remoteID,arguments.siteid)  />
				<cfset cacheFactory.get( key, contentBean.getAllValues() ) />
				<cfreturn contentBean/>
			<cfelse>
				<cfset contentBean=variables.contentDAO.getBean()/>
				<cfset contentBean.setAllValues(cacheFactory.get( key ))>
				<cfreturn contentBean />
			</cfif>
		<cfelse>
			<cfreturn variables.contentDAO.readActiveByRemoteID(arguments.remoteID,arguments.siteid)/>
		</cfif>
		
	</cffunction>

	<cffunction name="getActiveContent" access="public" returntype="any" output="false">
		<cfargument name="contentID" type="string" required="yes" />
		<cfargument name="siteID" type="string" required="yes" />
		<cfargument name="use404" type="boolean" required="yes" default="false"/>
		
		<cfset var key=arguments.siteid & arguments.contentID />
		<cfset var site=variables.settingsManager.getSite(arguments.siteid)/>
		<cfset var cacheFactory=site.getCacheFactory()/>
		<cfset var contentBean=""/>
		
		<cfif site.getCache()>
			<!--- check to see if it is cached. if not then pass in the context --->
			<!--- otherwise grab it from the cache --->
			<cfif NOT cacheFactory.has( key )>
				<cfset contentBean=variables.contentDAO.readActive(arguments.contentID,arguments.siteid,arguments.use404)  />
				<cfset cacheFactory.get( key, contentBean.getAllValues() ) />
				<cfreturn contentBean/>
			<cfelse>
				<cfset contentBean=variables.contentDAO.getBean()/>
				<cfset contentBean.setAllValues(cacheFactory.get( key ))>
				<cfreturn contentBean />
			</cfif>
		<cfelse>
			<cfreturn variables.contentDAO.readActive(arguments.contentID,arguments.siteid,arguments.use404) />
		</cfif>
	
	</cffunction>

	<cffunction name="getPageCount" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getPageCount(arguments.siteid) />
		
		<cfreturn rs />
	</cffunction>

	<cffunction name="getComponents" access="public" returntype="query" output="false">
		<cfargument name="moduleid" type="string"/>
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getComponents(arguments.moduleid,arguments.siteid) />
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getCrumbList" access="public" returntype="array" output="false">
		<cfargument name="contentid" type="string"/>
		<cfargument name="siteid" type="string"/>
		<cfset var array ="" />
		
		<cfset array=variables.contentGateway.getCrumbList(arguments.contentid,arguments.siteid) />
		
		<cfreturn array />
	</cffunction>
	
	<cffunction name="dspCrumblistTop" access="public" returntype="string" output="false">
		<cfargument name="crumbdata" type="array"/>
		<cfset var str ="" />
		
		<cfset str=variables.contentNavigation.dspCrumblistTop(arguments.crumbdata) />
		
		<cfreturn str />
	</cffunction>

	<cffunction name="getSections" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string"/>
		<cfargument name="type" type="string" required="true" default="" />
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getSections(arguments.siteid,arguments.type) />
		
		<cfreturn rs />
	</cffunction>

	<cffunction name="getSystemObjects" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getSystemObjects(arguments.siteid) />
		
		<cfreturn rs />
	</cffunction>

	<cffunction name="getComponentType" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string"/>
		<cfargument name="type" type="string"/>
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getComponentType(arguments.siteid,arguments.type) />
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="readRegionObjects" access="public" returntype="void" output="false">
		<cfargument name="contenthistid" type="string"/>
		<cfargument name="siteid" type="string"/>
		<cfset var rs = "" />
		<cfset var r = 0 />
		
		<cfloop index="r" from="1" to="#variables.settingsManager.getSite(arguments.siteid).getcolumncount()#">
		<cfset request["rsContentObjects#r#"]=variables.contentDAO.readRegionObjects(arguments.contenthistid,arguments.siteid,r) />
		</cfloop>

	</cffunction>


<cffunction name="setMaterializedPath" returntype="void" output="false">
<cfargument name="contentBean" type="any">
	<cfset var crumbdata=variables.contentGateway.getCrumbList(arguments.contentBean.getParentID(),arguments.contentBean.getSiteID(),false)>
	<cfset var path = "" />
	<cfset var I = 0 />
	
	<cfloop from="#arrayLen(crumbdata)#" to="1" index="I" step="-1">
		<cfset path =  listAppend(path,"#crumbdata[I].contentID#")>
	</cfloop>
		
	<cfset path = listAppend(path,"#arguments.contentBean.getcontentID()#")>
	
	<cfset arguments.contentBean.setPath(path)>

</cffunction>

<cffunction name="updateMaterializedPath" returntype="void" output="false">
<cfargument name="newPath" type="any">
<cfargument name="currentPath" type="any">
<cfargument name="siteID" type="any">

<cfset var fixerPath = ""/>
<cfset var rslist= "" />

	<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tcontent 
		set path=replace(ltrim(rtrim(cast(path AS char(1000)))),<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.currentPath#">,<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.newPath#">) 
		where path like	<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.currentPath#%">
		and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	</cfquery>
			
</cffunction>

<cffunction name="add" access="public" returntype="any" output="false">
	<cfargument name="data" type="any"/>
	<cfset var newBean=""/>
	<cfset var currentBean=""/>
	<cfset var deletedList=""/>
	<cfset var rsHist=""/>
	<cfset var histList=""/>
	<cfset var draftList=""/>
	<cfset var ext=""/>
	<cfset var rsOrder=""/>
	<cfset var fileID=""/>
	<cfset var theFileStruct=""/>
	<cfset var refused=false />
	<cfset var imageData="" />
	<cfset var rsFile="" />
	<cfset var rsDrafts = "" />
	<cfset var d = "" />
	<cfset var pluginEvent = createObject("component","mura.event") />
	
	<!---IF THE DATA WAS SUBMITTED AS AN OBJECT UNPACK THE VALUES --->
	<cfif isObject(arguments.data)>
		<cfif getMetaData(arguments.data).name eq "mura.content.contentBean">
			<cfset arguments.data=arguments.data.getAllValues() />
		<cfelse>
			<cfthrow type="custom" message="The attribute 'DATA' is not of type 'mura.content.contentBean'.">
		</cfif>
	</cfif>
	
	<!--- MAKE SURE ALL REQUIRED DATA IS THERE--->
	<cfif not structKeyExists(arguments.data,"siteID") or (structKeyExists(arguments.data,"siteID") and not len(arguments.data.siteID))>
		<cfthrow type="custom" message="The attribute 'SITEID' is required when saving content.">
	</cfif>
	
	<cfif not structKeyExists(arguments.data,"parentID") or (structKeyExists(arguments.data,"parentID") and not len(arguments.data.parentID))>
		<cfthrow type="custom" message="The attribute 'PARENTID' is required when saving content.">
	</cfif>
	
	<cfif not structKeyExists(arguments.data,"type") or (structKeyExists(arguments.data,"type") and not listFindNoCase("Form,Component,Page,Portal,Gallery,Calendar,File,Link",arguments.data.type))>
		<cfthrow type="custom" message="A valid 'TYPE' is required when saving content.">
	</cfif>
	
	<cfif (not structKeyExists(arguments.data,"title") or (structKeyExists(arguments.data,"title") and not len(arguments.data.title))) and
		(not structKeyExists(arguments.data,"menutitle") or (structKeyExists(arguments.data,"menutitle") and not len(arguments.data.menutitle)))>
		<cfthrow type="custom" message="The attribute 'TITLE' is required when saving content.">
	</cfif>
	
	<cfif not structKeyExists(arguments.data,"display") or (structKeyExists(arguments.data,"display") and not isNumeric(arguments.data.display))>
		<cfset arguments.data.display=1 />
	</cfif>
	
	<cfif not structKeyExists(arguments.data,"isNav") or (structKeyExists(arguments.data,"isNav") and not isNumeric(arguments.data.isNav))>
		<cfset arguments.data.isNav=1 />
	</cfif>
	
	<cfif not structKeyExists(arguments.data,"approved") or (structKeyExists(arguments.data,"approved") and not isNumeric(arguments.data.approved))>
		<cfset arguments.data.approved=0 />
	</cfif>
	<!--- END REQUIRED DATA CHECK--->
	
	<cfset pluginEvent.init(arguments.data)/>
	
	<cflock type="exclusive" name="editingContent#arguments.data.siteid#" timeout="600">
	<cftransaction>
	
	<!--- BEGIN CONTENT TYPE: ALL CONTENT TYPES --->
	<cfif isDefined('arguments.data.remoteID') and arguments.data.remoteID neq ''>
		
		<cfset newBean=variables.contentDAO.readActiveByRemoteID('#arguments.data.remoteID#','#arguments.data.siteid#') />
		
		<cfif  newBean.getIsNew() and isdefined("arguments.data.mode") and arguments.data.mode eq 'import' and (isDefined('arguments.data.remotePubDate') and arguments.data.remotePubDate eq newBean.getRemotePubDate()) >
			<cfset refused = true />
		</cfif>
	<cfelse>
		<cfset newBean=variables.contentDAO.readActive(arguments.data.contentID,arguments.data.siteid) />	
	</cfif>


<cfif not refused>
	<cfset newBean.set(arguments.data) />
	
	<cfif newBean.getIsNew()>
		<cfset newBean.setActive(1) />
		<cfset newBean.setCreated(now()) />
	<cfelse>
		<cfset newBean.setActive(0) />
	</cfif>
		
	<cfif not newBean.getIsNew()>
		<cfset currentBean=variables.contentDAO.readActive(newBean.getcontentID(),arguments.data.siteid) />
	</cfif>

	<cfif newBean.getcontentID() eq ''>
		<cfset newBean.setcontentID(createUUID()) />
	</cfif>

	<cfset newBean.setcontentHistID(createUUID()) />
	
	<cfif newBean.getTitle() eq ''>
		<cfset newBean.setTitle(newBean.getmenutitle())>
	</cfif>

	<cfif newBean.getmenuTitle() eq ''>
		<cfset newBean.setmenutitle(newBean.getTitle())>
	</cfif>
	
	<!--- END CONTENT TYPE: ALL CONTENT TYPES --->
	
	<!--- BEGIN CONTENT TYPE: ALL SITE TREE LEVEL CONTENT TYPES --->
	<cfif  newBean.getType() eq "Page" 
		or newBean.getType() eq "Portal" 
		or newBean.getType() eq "Calendar"
		or newBean.getType() eq "Link"
		or newBean.getType() eq "File"
		or newBean.getType() eq "Gallery">
		
		<cfif isDefined('arguments.data.extendSetID')>
			<cfset variables.ClassExtensionManager.saveExtendedData(newBean.getcontentHistID(),arguments.data)/>
		</cfif>
	
		<cfif not newBean.getIsNew()>
			<cfset variables.ClassExtensionManager.preserveExtendedData(newBean.getcontentHistID(),currentBean.getcontentHistID(),arguments.data)/>
		</cfif>
	
		<cfif newBean.getapproved() and not newBean.getIsNew() and currentBean.getDisplay() eq 2 and newBean.getDisplay() eq 2>
			<cfset variables.reminderManager.updateReminders(newBean.getcontentID(),newBean.getSiteid(),newBean.getDisplayStart()) />
		<cfelseif newBean.getapproved() and not newBean.getIsNew() and currentBean.getDisplay() eq 2 and newBean.getDisplay() neq 2>
			<cfset variables.reminderManager.deleteReminders(newBean.getcontentID(),newBean.getSiteID()) />
		</cfif>
	
		<cfset setMaterializedPath(newBean) />
		
		<cfif not newBean.getIsNew() and newBean.getParentID() neq currentBean.getParentID()>
			<cfset updateMaterializedPath(newBean.getPath(),currentBean.getPath(),newBean.getSiteID()) />
		</cfif>
		
		<cfif not newBean.getIsNew()>
			<cfset variables.contentDAO.createRelatedItems(newBean.getcontentID(),
			newBean.getcontentHistID(),arguments.data,newBean.getSiteID(),currentBean.getcontentHistID()) />
		
		<cfelse>
			<cfset variables.contentDAO.createRelatedItems(newBean.getcontentID(),
			newBean.getcontentHistID(),arguments.data,newBean.getSiteID(),'') />
		</cfif>
			
		<cfif not newBean.getIsNew() and isdefined("arguments.data.mode") and arguments.data.mode eq 'import'>
			
			<cfset variables.categoryManager.keepCategories(newBean.getcontentHistID(),
			getCategoriesByHistID(currentBean.getcontentHistID())) />	
		<cfelse>
			<cfif newBean.getIsNew()>
				<cfset variables.categoryManager.setCategories(arguments.data,newBean.getcontentID(),
				newBean.getcontentHistID(),arguments.data.siteid,getCategoriesByHistID('')) />	
			<cfelse>
				<cfset variables.categoryManager.setCategories(arguments.data,newBean.getcontentID(),
				newBean.getcontentHistID(),arguments.data.siteid,getCategoriesByHistID(currentBean.getcontentHistID())) />	
			</cfif>	
		</cfif>
	</cfif>
	
	<!--- Public Content Submision  --->
	<cfif  isdefined('arguments.data.email') and isdefined('arguments.data.email')>
				
				<cfset variables.contentUtility.setApprovalQue(newBean,arguments.data.email) />
	</cfif>
	
			<cfif newBean.getIsNew() eq 0 and newBean.getDisplay() neq 0 and currentBean.getDisplay() eq 0>
				 <cfset variables.contentUtility.checkApprovalQue(newBean,getActiveContent(newBean.getParentID(),newBean.getSiteID())) />
			</cfif>
	<!--- End Public Content Submision  --->	
	
	<!--- END CONTENT TYPE: ALL SITE TREE LEVEL CONTENT TYPES --->
	
	<!--- BEGIN CONTENT TYPE: PAGE, PORTAL, CALENDAR, GALLERY --->
	<cfif newBean.gettype() eq 'Page' or newBean.gettype() eq 'Portal' or newBean.gettype() eq 'Calendar' or newBean.gettype() eq 'Gallery'>
	
		<cfif not newBean.getIsNew()>	
			<cfset newBean.setfilename(currentBean.getfilename())>
			<cfset newBean.setOldfilename(currentBean.getfilename())>
		</cfif>
			
		<cfif 
			(
				(newBean.getapproved() or newBean.getIsNew())
				 and newBean.getcontentid() neq '00000000000000000000000000000000001'
				) 
				  and 
				(newBean.getIsNew()
				 or
				(
				  not newBean.getIsNew() 
				  and (
					 	currentBean.getparentid() neq newBean.getparentid()
					or currentBean.getmenutitle() neq newBean.getmenutitle()
				   )
			  	)
			  )
					   
		 	  and 
				(
				not 
					(
					newBean.getparentid() eq '00000000000000000000000000000000001'
				   	and  variables.settingsManager.getSite(newBean.getsiteid()).getlocking() eq 'top'
					) 
			and not variables.settingsManager.getSite(newBean.getSiteID()).getlocking() eq 'all'
			)
			
			and not (not newBean.getIsNew() and newBean.getIsLocked())>
						
			<cfset variables.contentUtility.setUniqueFilename(newBean) />
			<!---<cfset variables.contentUtility.createFile(newBean) />--->
			
					
			<cfif not newBean.getIsNew() and newBean.getoldfilename() neq newBean.getfilename()>
				<cfset variables.contentUtility.movelink(newBean.getSiteID(),newBean.getFilename(),currentBean.getFilename()) />	
				<cfset variables.contentUtility.move(newBean.getsiteid(),newBean.getFilename(),newBean.getOldFilename())>
			</cfif>
				
		</cfif>		
		
		<cfif newBean.getIsNew()>
		<cfset variables.contentDAO.createObjects(arguments.data,newBean,'') />
		<cfelse>
		<cfset variables.contentDAO.createObjects(arguments.data,newBean,currentBean.getcontentHistID()) />
		</cfif>
		
		<cfif isDefined('arguments.data.deleteFile') and len(newBean.getFileID())>
		<cfset variables.fileManager.deleteIfNotUsed(newBean.getFileID(),newBean.getContentHistID())>
		<cfset newBean.setFileID('')>
		</cfif>
				
	</cfif>
	<!--- END CONTENT TYPE: PAGE, PORTAL, CALENDAR, GALLERY --->
	

	<!--- BEGIN CONTENT TYPE: FILE --->	
	<!---<cfif newBean.gettype() eq 'File'>--->
			
		<cfif isDefined('arguments.data.newfile') and arguments.data.newfile neq ''>
			
			<cffile action="upload" filefield="NewFile" nameconflict="makeunique" destination="#getTempDirectory()#">
			<cfset theFileStruct=variables.fileManager.process(cffile,newBean.getSiteID()) />
			<cfset newBean.setfileID(variables.fileManager.create(theFileStruct.fileObj,newBean.getcontentID(),newBean.getSiteID(),cffile.ClientFile,cffile.ContentType,cffile.ContentSubType,cffile.FileSize,newBean.getModuleID(),cffile.ServerFileExt,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium)) />
			
			<cfif newBean.getType() eq "File">
				<cfset newBean.setfilename(cffile.serverfile) />
			</cfif>
			
			<!--- Delete Files in temp directory --->
			
		</cfif>
		<!--- Delete Files that are not attached to any version in versin history--->	
		<cfif newBean.getApproved() and not newBean.getIsNew()>
	
				<cfset rsHist=getArchiveHist(newbean.getcontentID(),arguments.data.siteid)/>
				<cfset rsDrafts=getDraftHist(newbean.getcontentID(),arguments.data.siteid)/>
					
				<cfloop query="rsHist">
					<cfset histList=listAppend(histList,rsHist.filename,"^")/>
				</cfloop>
				
				<cfloop query="rsDrafts">
					<cfset draftList=listAppend(draftList,rsDrafts.filename,"^")/>
				</cfloop>
					
				<cfloop list="#draftList#" index="d">
					<cfif newBean.getFilename() neq d and not listFind(histList,d,"^") and not listFind(deletedList,d,"^")>
						<cftry>
						<cflock name="#d#" type="exclusive" timeout="500">
						<cfset variables.fileManager.deleteVersion(d) />
						</cflock>
						<cfcatch></cfcatch>
						</cftry>
						<cfset deletedList=listAppend(deletedList,d,"^")/>
					</cfif>

					
				</cfloop>
		</cfif>
	
	<!---</cfif>--->
	<!--- END CONTENT TYPE: FILE --->
		

	<!--- BEGIN CONTENT TYPE: ALL CONTENT TYPES --->
	<!---If approved, delete all drafts and set the last active to inactive--->
		
	<cfif newBean.getapproved() and not newBean.getIsNew()>
		
		<cfset newBean.setActive(1) />
		<cfset variables.contentDAO.archiveActive(newbean.getcontentID(),arguments.data.siteid)/>
		<cfset variables.contentDAO.deleteDraftHistAll(newbean.getcontentID(),arguments.data.siteid)/>
		<cfset variables.contentDAO.deleteContentAssignments(newbean.getcontentID(),arguments.data.siteid)/>
	</cfif>
		
	<cfif newBean.getapproved()>
		<cfset variables.settingsManager.getSite(arguments.data.siteid).purgeCache() />
	</cfif>
		
		
	<!--- set the orderno if it is new content or has been moved--->	 
	<cfif newBean.getIsNew() 
	or (newBean.getapproved() and not newBean.getIsNew() and newBean.getParentID() neq currentBean.getParentID() )>		 
		
		<cfif not isdefined('arguments.data.topOrBottom') or isdefined('arguments.data.topOrBottom') and arguments.data.topOrBottom eq 'Top' >
			<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			 update tcontent set orderno=OrderNo+1 where parentid='#newBean.getparentid()#' 
			 and siteid='#newBean.getsiteid()#' 
			 and type in ('Page','Portal','Link','File','Component','Calendar','Form') and active=1
			 </cfquery>
				 
			 <cfset newBean.setOrderNo(1)>
			 
		<cfelseif (isdefined('arguments.data.topOrBottom') and arguments.data.topOrBottom eq 'bottom')>
		
			<cfif not newBean.getIsNew() and newBean.getParentID() eq currentBean.getParentID()>
				<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				 update tcontent set orderno=OrderNo-1 where parentid='#newBean.getparentid()#' 
				 and siteid='#newBean.getsiteid()#' 
				 and type in ('Page','Portal','Link','File','Component','Calendar','Form') and active=1
				 and orderno > #currentBean.getOrderNo()#
			 	</cfquery>
			</cfif>

			<cfquery name="rsOrder" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			 select max(orderno) as theBottom from tcontent where parentid='#newBean.getparentid()#' 
			 and siteid='#newBean.getsiteid()#' 
			 and type in ('Page','Portal','Link','File','Component','Calendar','Form') and active=1
			 </cfquery>
			 
			<cfif rsOrder.theBottom neq newBean.getOrderNo()>
				<cfset newBean.setOrderNo(rsOrder.theBottom + 1) />/>
			</cfif>
		</cfif>
			 
		<cfif not newBean.getIsNew() and newBean.getParentID() neq currentBean.getParentID() >
			<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			update tcontent set parentid='#newBean.getparentid()#' where contentid='#newBean.getcontentid()#' 
			and active=0 and siteid='#newBean.getsiteid()#'
			</cfquery>
		</cfif>
		
				
					 
	</cfif>	 
	
	<!--- Send out notification(s) if needed--->
	<cfif isdefined('arguments.data.notify') and arguments.data.notify neq ''>
		<cfset variables.contentUtility.sendNotices(arguments.data,newBean) />
	</cfif>
	
	<cfset variables.contentDAO.createTags(newBean) />
	
	<cfset variables.utility.logEvent("ContentID:#newBean.getcontentID()# ContentHistID:#newBean.getcontentHistID()# MenuTitle:#newBean.getMenuTitle()# Type:#newBean.getType()# was created","mura-content","Information",true) />
	<cfset variables.contentDAO.create(newBean) />
	<!--- END CONTENT TYPE: ALL CONTENT TYPES --->
	
	
	<cfset pluginEvent.setValue("contentBean",newBean)>
	<cfif  ListFindNoCase("Page,Portal,Calendar,Link,File,Gallery",newBean.getType())>			
		<cfset variables.pluginManager.executeScripts("onContentSave",newBean.getSiteID(),pluginEvent)>	
	</cfif>
		
	<cfset variables.pluginManager.executeScripts("on#newBean.getType()#Save",newBean.getSiteID(),pluginEvent)>
		

</cfif>	
<!--- end non refused content --->

	</cftransaction>
	</cflock>	
	
	

	<cfreturn newBean />
	
</cffunction>


	<cffunction name="deleteall" access="public" returntype="string" output="false" hint="Deletes everything">
	<cfargument name="data" type="struct"/>
	<cfset var currentBean="" />
	<cfset var rsHist=""/>
	<cfset var fileList=""/>
	<cfset var newPath=""/>
	<cfset var currentPath=""/>
	<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
	
	<cflock type="exclusive" name="editingContent#arguments.data.siteid#" timeout="60">
		<cfset currentBean=variables.contentDAO.readActive(arguments.data.contentid,arguments.data.siteid) />
		<cfset pluginEvent.setValue("contentBean",currentBean) />	
		<cfif currentBean.getContentID() neq '00000000000000000000000000000000001'>
				
			<cfif currentBean.getIsLocked() neq 1>
			
				<cfif  ListFindNoCase("Page,Portal,Calendar,Link,File,Gallery",currentBean.getType())>	
				
					<cfset variables.pluginManager.executeScripts("onContentDelete",currentBean.getSiteID(),pluginEvent)>
					
					<cfif currentBean.getPath() neq "">
						<cfset newPath=listDeleteAt(currentBean.getPath(),listLen(currentBean.getPath())) />
						<cfset currentPath=currentBean.getPath() />
						<cfset updateMaterializedPath(newPath,currentPath,currentBean.getSiteID()) />
					</cfif>
				</cfif>
				
				<cfset variables.pluginManager.executeScripts("on#currentBean.getType()#Delete",currentBean.getSiteID(),pluginEvent)>
				
				<cfif len(currentBean.getFileID()) or currentBean.getType() eq 'Form'>
					<cfset variables.fileManager.deleteAll(currentBean.getcontentID()) />
				</cfif>
					<cfset variables.contentUtility.deleteFile(currentBean) />
					
					<cfif currentBean.getType() neq 'File'>
						<cfset variables.contentDAO.deleteObjects(currentBean.getcontentID(),currentBean.getSiteID()) />
						<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
							 update tcontent set orderno=OrderNo-1 where parentid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#currentBean.getParentID()#"> 
							 and siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#currentBean.getSiteID()#">
							 and type in ('Page','Portal','Link','File','Component','Calendar','Form') and active=1
							 and orderno > <cfqueryparam cfsqltype="cf_sql_numeric" value="#currentBean.getOrderNo()#">
							</cfquery>
					</cfif>
				
				<cfset variables.utility.logEvent("ContentID:#currentBean.getcontentID()# MenuTitle:#currentBean.getMenuTitle()# Type:#currentBean.getType()# was completely deleted","mura-content","Information",true) />		
				<cfset variables.contentDAO.delete(currentBean) />
				
			</cfif>
			
		<cfelse>
			<cfreturn currentBean.getContentID() />
		</cfif>	
	
	</cflock>
	
	<cfset variables.settingsManager.getSite(arguments.data.siteid).purgeCache() />
	
	<cfif structKeyExists(data,"topID")>
		<cfif data.topid eq currentBean.getcontentid()>
		 	<cfreturn currentBean.getParentID() />
		<cfelse>
			<cfreturn data.topid />
		</cfif>
	<cfelse>
		<cfreturn currentBean.getParentID() />
	</cfif>
	

	</cffunction>
	
	<cffunction name="deletehistall" access="public" returntype="void" output="false" hint="Clears an item's version history">
		<cfargument name="data" type="struct"/>
		<cfset var rsHist=""/>
		<cfset var versionBean=""/>
		<cfset var fileList=""/>
		<cfset var currentBean=getActiveContent(arguments.data.contentid,arguments.data.siteid)/>
		<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
		
		<cfset pluginEvent.setValue("contentBean",currentBean)/>
		
		<cfif  ListFindNoCase("Page,Portal,Calendar,Link,File,Gallery",currentBean.getType())>				
			<cfset variables.pluginManager.executeScripts("onContentDeleteVersionHistory",currentBean.getSiteID(),pluginEvent)>	
		</cfif>
		
		<cfset variables.pluginManager.executeScripts("on#currentBean.getType()#DeleteVersionHistory",currentBean.getSiteID(),pluginEvent)>
		
		<cfset rsHist=getHist(arguments.data.contentid,arguments.data.siteid)/>
		<cfset fileList=currentBean.getFileID()/>
		<cfloop query="rsHist">
			<cfif rshist.active neq 1 and len(rshist.FileID)>
					<cfif not listFind(fileList,rshist.FileID,"^")>
						<cfset variables.filemanager.deleteVersion(rshist.FileID,false) />
						<cfset fileList=listAppend(fileList,rshist.FileID,"^")/>
					</cfif>		
			</cfif>			
		</cfloop>
		
		<cfset variables.utility.logEvent("ContentID:#currentBean.getcontentID()# MenuTitle:#currentBean.getMenuTitle()# Type:#currentBean.getType()# version history was deleted","mura-content","Information",true) />
		<cfset variables.contentDAO.deletehistall(data.contentid,data.siteid) />
		
	</cffunction>

	<cffunction name="delete" access="public" returntype="void" output="false" hint="Deletes a version from version history">
		<cfargument name="data" type="struct"/>
		
		<cfset var versionBean=getcontentVersion(arguments.data.contenthistid,arguments.data.siteid)/>
		<cfset var currentBean=""/>
		<cfset var fileList=""/>
		<cfset var rsHist = "" />
		<cfset var pluginEvent = createObject("component","mura.event").init(arguments.data) />
		
		<cfset pluginEvent.setValue("contentBean",versionBean)/>
		
		<cfif  ListFindNoCase("Page,Portal,Calendar,Link,File,Gallery",versionBean.getType())>				
			<cfset variables.pluginManager.executeScripts("onContentDeleteVersion",versionBean.getSiteID(),pluginEvent)>	
		</cfif>
		
		<cfset variables.pluginManager.executeScripts("on#versionBean.getType()#DeleteVersion",versionBean.getSiteID(),pluginEvent)>
		
		<cfif len(versionBean.getFileID())>
			<cfset rsHist=getHist(versionBean.getcontentid(),arguments.data.siteid)/>
			<cfloop query="rsHist">
				<cfif len(rsHist.fileID) and rsHist.contentHistID neq arguments.data.contentHistID>
					<cfset fileList=listAppend(fileList,rsHist.fileID,"^")/>
				</cfif>
			</cfloop>
			<cfif not listFind(fileList,versionBean.getFileID(),"^")>
				<cfset variables.filemanager.deleteVersion(versionBean.getFileID()) />
			</cfif>
		</cfif>
		
		<cfset variables.utility.logEvent("ContentID:#versionBean.getcontentID()# ContentHistID:#versionBean.getcontentHistID()# MenuTitle:#versionBean.getMenuTitle()# Type:#versionBean.getType()#  version was deleted","mura-content","Information",true) />		
		<cfset variables.contentDAO.deletehist(arguments.data.contenthistid,arguments.data.siteid) />
		<cfset variables.contentDAO.deleteTagHist(arguments.data.contenthistid,arguments.data.siteid) />
		<cfset variables.contentDAO.deleteObjectsHist(arguments.data.contenthistid,arguments.data.siteid) />
		<cfset variables.contentDAO.deleteCategoryHist(arguments.data.contenthistid,arguments.data.siteid) />
		<cfset variables.contentDAO.deleteExtendDataHist(arguments.data.contenthistid,arguments.data.siteid) />
		
	</cffunction>

	<cffunction name="getDownloadselect" access="public" returntype="query" output="false">
		<cfargument name="contentid" type="string"/>
		<cfargument name="siteid" type="string"/>
		<cfset var rs = "" />

		<cfset rs=variables.contentGateway.getDownloadselect(arguments.contentid,arguments.siteid) />
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="getReportData" access="public" returntype="void" output="false">
		<cfargument name="data" type="struct"/>
		<cfargument name="contentBean" type="any"/>

		<cfset variables.contentUtility.getReportData(arguments.data,arguments.contentBean) />
		
	</cffunction>
	
	<cffunction name="setReminder" returntype="void" access="public" output="false">
		 <cfargument name="contentid" type="string">
		 <cfargument name="siteid" type="string">
		 <cfargument name="email" type="string">
		 <cfargument name="displayStart" type="string">
		 <cfargument name="remindInterval" type="numeric">
		 
		 <cfset variables.reminderManager.setReminder(arguments.contentid,arguments.siteid,arguments.email,arguments.displaystart,arguments.remindInterval)/>
		 
	 </cffunction>
	 
	<cffunction name="sendReminders" returntype="void" access="public" output="false">
	<cfargument name="theTime" default="#now()#" required="yes"/>

		<cfset variables.reminderManager.sendReminders(arguments.theTime) />
	
	</cffunction>
	
	<cffunction name="getPrivateSearch" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string"/>
		<cfargument name="keywords" type="string"/>
		<cfargument name="tag" required="true" default=""/>
		<cfargument name="sectionID" required="true" default=""/>
		
		<cfset var rs=""/>

		<cfset rs=variables.contentGateway.getPrivateSearch(arguments.siteid,arguments.keywords,arguments.tag,arguments.sectionID) />
		
		<cfreturn rs/>
		
	</cffunction>
	
	<cffunction name="getPublicSearch" access="public" returntype="query" output="false">
		<cfargument name="siteid" type="string"/>
		<cfargument name="keywords" type="string"/>
		<cfargument name="tag" required="true" default=""/>
		<cfargument name="sectionID" required="true" default=""/>
		
		<cfset var rs=""/>

		<cfset rs=variables.contentGateway.getPublicSearch(arguments.siteid,arguments.keywords,arguments.tag,arguments.sectionID) />
		
		<cfreturn rs/>
		
	</cffunction>
	
	<cffunction name="getCategoriesByHistID" returntype="query" access="public" output="false">
	<cfargument name="contentHistID" type="string" required="true">
		<cfset var rs ="" />
		
		<cfset rs=variables.contentGateway.getCategoriesByHistID(arguments.contentHistID) />
		
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="exportHtmlSite">
		<cfargument name="siteid" type="string" required="true" default="default" />

		<cfset traverseSite('00000000000000000000000000000000END', arguments.siteid, variables.settingsManager.getSite(arguments.siteid).getExportLocation()) />
		<cfset variables.utility.copyDir("#variables.configBean.getWebRoot()#\#arguments.siteid#\client_images\", "#variables.configBean.getWebRoot()#\#variables.settingsManager.getSite(arguments.siteid).getExportLocation()#\client_images\") />
		<cfset variables.utility.copyDir("#variables.configBean.getWebRoot()#\#arguments.siteid#\css\", "#variables.configBean.getWebRoot()#\#variables.settingsManager.getSite(arguments.siteid).getExportLocation()#\css\") />
		<cfset variables.utility.copyDir("#variables.configBean.getWebRoot()#\#arguments.siteid#\flash\", "#variables.configBean.getWebRoot()#\#variables.settingsManager.getSite(arguments.siteid).getExportLocation()#\flash\") />
		<cfset variables.utility.copyDir("#variables.configBean.getWebRoot()#\#arguments.siteid#\images\", "#variables.configBean.getWebRoot()#\#variables.settingsManager.getSite(arguments.siteid).getExportLocation()#\images\") />
		<cfset variables.utility.copyDir("#variables.configBean.getWebRoot()#\#arguments.siteid#\js\", "#variables.configBean.getWebRoot()#\#variables.settingsManager.getSite(arguments.siteid).getExportLocation()#\js\") />
	
	</cffunction>
	
	<cffunction name="traverseSite">
		<cfargument name="contentid" type="string" required="true" />
		<cfargument name="siteid" type="string" required="true" default="default" />
		<cfargument name="exportLocation" type="string" required="true" default="export" />
		<cfargument name="sortBy" type="string" required="yes" default="orderno" />
		<cfargument name="sortDirection" type="string" required="yes" default="asc" />
		<cfset var rs = "" />
		<cfset var fileOutput = "" />
		<cfset var rsFile = "" />
		<cfset var contentBean = "" />
		<cfset var filepath = "" />
		<cfset var basepath = "" />
		<cfset var servlet = "" />

		<cfset request.exportHtmlSite = 1>
		<cfset request.siteid = arguments.siteid>
		
		<cfset rs=getNest(arguments.contentid,arguments.siteid,arguments.sortBy,arguments.sortDirection) />
		
		<cfloop query="rs">
			<cfif rs.hasKids>
				<cfset traverseSite(rs.contentID, arguments.siteid, arguments.exportLocation) />	
			</cfif>
			
			<cfset basepath = "#variables.configBean.getWebRoot()#\#arguments.exportLocation#">
			
			<cfif rs.type eq "file">
				<cfset contentBean=application.contentManager.getActiveContent(rs.contentID,arguments.siteid) />
				<cfset rsFile=application.serviceFactory.getBean('fileManager').read(contentBean.getfileid()) />
				<cfset fileOutput = rsFile.image>
				<cfset filePath = "#basepath#\#replace(contentBean.getcontentID(), '-', '', 'ALL')#.#rsfile.fileExt#">
			<cfelse>
				<cfset request.filename = rs.filename>
				<cfset servlet=createObject("component","mura.servlet").init()/>
				<cfset fileOutput=servlet.doRequest()>
				<cfset filePath = "#basepath#\#rs.filename#\index.htm">
				
				<cftry>
				<cfdirectory action="create" directory="#basepath#\#rs.filename#">
				<cfcatch></cfcatch>
				</cftry>
			</cfif>
			
			<cftry>
			<cffile 
			   action = "write" 
			   file = "#filepath#"
			   output = "#fileOutput#" >
			<cfcatch></cfcatch>
			</cftry>
			
		</cfloop>
	
	</cffunction>
	
	<cffunction name="getRelatedContent" returntype="query" access="public" output="false">
		<cfargument name="siteID"  type="string" />
		<cfargument name="contentHistID"  type="string" />
		<cfargument name="liveOnly" type="boolean" required="yes" default="false" />
		<cfargument name="today" type="date" required="yes" default="#now()#" />
	
		<cfreturn variables.contentGateway.getRelatedContent(arguments.siteID,arguments.contentHistID,arguments.liveOnly,arguments.today) />
	</cffunction>
	
	<cffunction name="copy" returntype="void" access="public" output="false">
		<cfargument name="siteID" type="string" />
		<cfargument name="contentID" type="string" />
		<cfargument name="parentID" type="string" />

		<cfset variables.contentUtility.copy(arguments.siteID, arguments.contentID, arguments.parentID)>
	</cffunction>
	
	<cffunction name="saveCopyInfo" returntype="void" access="public" output="false">
		<cfargument name="siteID" type="string" />
		<cfargument name="contentID" type="string" />
		
		<cfset session.copySiteID = arguments.siteID>
		<cfset session.copyContentID = arguments.contentID>
	</cffunction>
	
	<cffunction name="deleteAllWithNestedContent">
	<cfargument name="data" type="struct"/>
	<cfset var rs ="">
	<cfset var subContent = structNew() />
	
	
		<cfif arguments.data.contentID eq '00000000000000000000000000000000001'>
			<cfabort>
		</cfif>
		
		<cfquery name="rs" datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select contentID from tcontent where parentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.data.contentID#">
		and active = 1
		</cfquery>
		
		<cfif rs.recordcount>
			<cfloop query="rs">
				<cfset subContent.contentID = rs.contentiD/>
				<cfset subContent.siteID = arguments.data.siteID/>
				<cfset deleteAllWithNestedContent(subContent)/>
			</cfloop>
		</cfif>
		
		<cfset deleteAll(arguments.data)/>
	
	
	</cffunction>
	
	<cffunction name="getStatsBean" access="public" returntype="any">
	<cfreturn createObject("component","contentStatsBean").init(variables.configBean)>
	</cffunction>
	
	<cffunction name="getCommentBean" access="public" returntype="any">
	<cfreturn createObject("component","contentCommentBean").init(variables.configBean,variables.settingsManager,variables.utility,variables.contentDAO)>
	</cffunction>
	
	<cffunction name="readComments" access="public" output="false" returntype="query">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	<cfargument name="isEditor" type="boolean" required="true" default="false">
	<cfargument name="sortOrder" type="string" required="true" default="asc">
	
	<cfreturn variables.contentDAO.readComments(arguments.contentID,arguments.siteid,arguments.isEditor,arguments.sortOrder) />
	
	</cffunction>
	
	<cffunction name="getCommentCount" access="public" output="false" returntype="numeric">
	<cfargument name="contentID" type="String" required="true" default="">
	<cfargument name="siteID" type="string" required="true" default="">
	
	<cfreturn variables.contentDAO.getCommentCount(arguments.contentID,arguments.siteid) />
	
	</cffunction>
	
	<cffunction name="saveComment" access="public" output="false" returntype="any">
		<cfargument name="data" type="struct">
		<cfargument name="contentRenderer" required="true" default="#application.contentRenderer#">
		<cfargument name="script" required="true" default="">
		<cfargument name="subject" required="true" default="">
		
		<cfset var commentBean=getCommentBean() />
		<cfset commentBean.set(arguments.data) />
		<cfset commentBean.save() />
		<cfif commentBean.getIsApproved()>
			<cfset commentBean.notifySubscribers(arguments.contentRenderer,arguments.script,arguments.subject)>
		</cfif>
		<cfset setCommentStat(commentBean.getContentID(),commentBean.getSiteID()) />
		<cfreturn commentBean />
	</cffunction>
	
	<cffunction name="deleteComment" access="public" output="false" returntype="any">
		<cfargument name="commentID" type="string">
			<cfset var commentBean=getCommentBean() />
			<cfset commentBean.setCommentID(arguments.commentid) />
			<cfset commentBean.delete() />
			<cfset setCommentStat(commentBean.getContentID(),commentBean.getSiteID()) />
			<cfreturn commentBean />
	</cffunction>
	
	<cffunction name="approveComment" access="public" output="false" returntype="any">
		<cfargument name="commentID" type="string">
		<cfargument name="contentRenderer" required="true" default="#application.contentRenderer#">
		<cfargument name="script" required="true" default="">
		<cfargument name="subject" required="true" default="">
		
			<cfset var commentBean=getCommentBean() />
			<cfset commentBean.setCommentID(arguments.commentid) />
			<cfset commentBean.load() />
			<cfset commentBean.setIsApproved(1) />
			<cfset commentBean.save() />
			<cfset commentBean.notifySubscribers(arguments.contentRenderer,arguments.script,arguments.subject)>
			<cfset setCommentStat(commentBean.getContentID(),commentBean.getSiteID()) />
			<cfreturn commentBean />
	</cffunction>
	
	<cffunction name="disapproveComment" access="public" output="false" returntype="any">
		<cfargument name="commentID" type="string">
			<cfset var commentBean=getCommentBean() />
			<cfset commentBean.setCommentID(arguments.commentid) />
			<cfset commentBean.load() />
			<cfset commentBean.setIsApproved(0) />
			<cfset commentBean.save() />
			<cfset setCommentStat(commentBean.getContentID(),commentBean.getSiteID()) />
			<cfreturn commentBean />
	</cffunction>
	
	<cffunction name="setCommentStat" access="public" output="false" returntype="void">
		<cfargument name="contentID" type="string">
		<cfargument name="siteID" type="string">
			<cfset var ln="l" &replace(arguments.contentID,"-","","all") />
			<cfset var stats = getStatsBean() />
			<cflock name="#ln#" timeout="10">
				<cfset stats.setContentID(arguments.contentID)/>
				<cfset stats.setSiteID(arguments.siteID)/>
				<cfset stats.load()/>
				<cfset stats.setComments(getCommentCount(arguments.contentID,arguments.siteID)) />
				<cfset stats.save()/>
			</cflock>
	</cffunction>
	
	<cffunction name="commentUnsubscribe" access="public" output="false" returntype="any">
		<cfargument name="contentID" type="string">
		<cfargument name="email" type="string">
		<cfargument name="siteID" type="string">
			<cfset var commentBean=getCommentBean() />
			<cfset commentBean.setContentID(arguments.contentid) />
			<cfset commentBean.setEmail(arguments.email) />
			<cfset commentBean.setSiteID(arguments.siteID) />
			<cfset commentBean.saveSubscription() />
	</cffunction>
	
	<cffunction name="multiFileUpload" access="public" output="false" returntype="void">
	<cfargument name="data" type="struct"/>
	<cfset var thefileStruct=structNew() />
	<cfset var fileItem=structNew() />		
	<cfset var f=1 />	
	<cfset var fileBean="" />
	
	<cfset fileItem.siteID=arguments.data.siteID/>
	<cfset fileItem.parentID=arguments.data.parentID/>
	<cfset fileItem.type="File" />
	<cfset fileItem.subType=arguments.data.subType />
	<cfset fileItem.display=1 />
	<cfset fileItem.isNav=1 />	
	<cfset fileItem.contentID=""/>
	<cfset fileItem.approved=arguments.data.approved/>
	
	<cfloop condition="structKeyExists(arguments.data,'newFile#f#')">
		<cfif len(form["NewFile#f#"])>
		<cffile action="upload" filefield="NewFile#f#" nameconflict="makeunique" destination="#getTempDirectory()#">
		<cfset theFileStruct=variables.fileManager.process(file,arguments.data.siteid) />		
		<cfset fileItem.title=file.serverfile/>
		<cfset fileItem.fileid=variables.fileManager.create(theFileStruct.fileObj,'',arguments.data.siteid,file.ClientFile,file.ContentType,file.ContentSubType,file.FileSize,"0000000000000000000000000000000000",file.ServerFileExt,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium) />
		<cfset fileBean=add(structCopy(fileItem)) />
		<cfquery datasource="#variables.configBean.getDatasource()#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			 update tfiles set contentID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileBean.getContentID()#"> 
			 where fileid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#fileBean.getFileID()#">
		</cfquery>
		</cfif>
		<cfset f=f+1 />			
	</cfloop>
	</cffunction>
</cfcomponent>