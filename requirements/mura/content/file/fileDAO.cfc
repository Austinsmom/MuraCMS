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
		<cfargument name="pluginManager" type="any" required="yes"/>
		<cfargument name="fileWriter" required="true" default=""/>
		
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.pluginManager=arguments.pluginManager />
		<cfset variables.fileWriter=arguments.fileWriter>
		<cfif variables.configBean.getFileStoreAccessInfo() neq ''>
			<cfset variables.s3=createObject("component","s3").init(
							listFirst(variables.configBean.getFileStoreAccessInfo(),'^'),
							listGetAt(variables.configBean.getFileStoreAccessInfo(),2,'^'),
							"#application.configBean.getFileDir()##application.configBean.getFileDelim()#s3cache#application.configBean.getFileDelim()#")>
			<cfif listLen(variables.configBean.getFileStoreAccessInfo(),"^") eq 3>
			<cfset variables.bucket=listLast(variables.configBean.getFileStoreAccessInfo(),"^") />
			<cfelse>
				<cfset variables.bucket="sava" />
			</cfif>
		<cfelse>
			<cfset variables.s3=""/>
			<cfset variables.bucket=""/>		
		</cfif>
		
		<cfset variables.dsn=variables.configBean.getDatasource()/>
<cfreturn this />
</cffunction>

<cffunction name="getS3" returntype="any" access="public" output="false">
	<cfreturn variables.s3 />
</cffunction>

<cffunction name="create" returntype="string" access="public" output="false">
		<cfargument name="fileObj" type="any" required="yes"/>
		<cfargument name="contentid" type="any" required="yes"/>
		<cfargument name="siteid" type="any" required="yes"/>
		<cfargument name="filename" type="any" required="yes"/>
		<cfargument name="contentType" type="string" required="yes"/>
		<cfargument name="contentSubType" type="string" required="yes"/>
		<cfargument name="fileSize" type="numeric" required="yes"/>
		<cfargument name="moduleID" type="string" required="yes"/>
		<cfargument name="fileExt" type="string" required="yes"/>
		<cfargument name="fileObjSmall" type="any" required="yes"/>
		<cfargument name="fileObjMedium" type="any" required="yes"/>
		<cfargument name="fileID" type="any" required="yes" default="#createUUID()#"/>
		
		<cfset var ct=arguments.contentType & "/" & arguments.contentSubType />
		<cfset var pluginEvent = createObject("component","mura.event").init(arguments) />
		<cfset variables.pluginManager.announceEvent("onBeforeFileCache",pluginEvent)>
		
		<cfswitch expression="#variables.configBean.getFileStore()#">
			<cfcase value="fileDir">
				<cfset variables.fileWriter.writeFile(mode="774", file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#.#arguments.fileExt#", output="#arguments.fileObj#")>
				<cfif listFindNoCase("png,gif,jpg,jpeg",arguments.fileExt)>
					<cfif isBinary(fileObjSmall)>
						<cfset variables.fileWriter.writeFile(mode="774", file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_small.#arguments.fileExt#", output="#arguments.fileObjSmall#")>
					</cfif>
					<cfif isBinary(fileObjMedium)>
						<cfset variables.fileWriter.writeFile(mode="774", file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_medium.#arguments.fileExt#", output="#arguments.fileObjMedium#")/>
					</cfif>
				<cfelseif arguments.fileExt eq 'flv'>
					<cfif isBinary(fileObjSmall)>
						<cfset variables.fileWriter.writeFile(mode="774", file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_small.jpg", output="#arguments.fileObjSmall#")>
					</cfif>
					<cfif isBinary(fileObjMedium)>
						<cfset variables.fileWriter.writeFile( mode="774",  file="#application.configBean.getFileDir()##application.configBean.getFileDelim()##arguments.siteid##application.configBean.getFileDelim()#cache#application.configBean.getFileDelim()#file#application.configBean.getFileDelim()##arguments.fileID#_medium.jpg", output="#arguments.fileObjMedium#")>
					</cfif>
				</cfif>
			</cfcase>
			<cfcase value="s3">
				<cfset variables.s3.putFileOnS3(arguments.fileObj,ct,variables.bucket,'#arguments.siteid#/#arguments.fileid#.#arguments.fileExt#') />
				<cfif arguments.fileExt eq 'jpg' or arguments.fileExt eq 'jpeg' or arguments.fileExt eq 'png' or arguments.fileExt eq 'gif'>
					<cfif isBinary(fileObjSmall)><cfset variables.s3.putFileOnS3(arguments.fileObjSmall,ct,variables.bucket,'#arguments.siteid#/#arguments.fileid#_small.#arguments.fileExt#') /></cfif>
					<cfif isBinary(fileObjMedium)><cfset variables.s3.putFileOnS3(arguments.fileObjMedium,ct,variables.bucket,'#arguments.siteid#/#arguments.fileid#_medium.#arguments.fileExt#') /></cfif>
				<cfelseif arguments.fileExt eq 'flv'>
					<cfif isBinary(fileObjSmall)><cfset variables.s3.putFileOnS3(arguments.fileObjSmall,'image/jpeg',variables.bucket,'#arguments.siteid#/#arguments.fileid#_small.jpg') /></cfif>
					<cfif isBinary(fileObjMedium)><cfset variables.s3.putFileOnS3(arguments.fileObjMedium,'image/jpeg',variables.bucket,'#arguments.siteid#/#arguments.fileid#_medium.jpg') /></cfif>
				</cfif>
			</cfcase>
		</cfswitch>
		
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		INSERT INTO tfiles (fileID,contentID,siteID,filename,contentType,contentSubType,fileSize,moduleID,fileExt,created<cfif variables.configBean.getFileStore() eq 'database'>,image,imageSmall,imageMedium</cfif>)
		VALUES(
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.fileid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.contentid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.siteid#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.filename#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.contentType#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.contentSubType#">,
		<cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.fileSize#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.moduleID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  null="#iif(arguments.fileExt eq '',de('yes'),de('no'))#" value="#arguments.fileExt#">,
		#createODBCDateTime(now())#
		<cfif variables.configBean.getFileStore() eq 'database'>,
		<cfqueryparam cfsqltype="cf_sql_blob"  value="#arguments.fileObj#">,
		<cfqueryparam cfsqltype="cf_sql_blob"  null="#iif(isBinary(arguments.fileObjSmall),de('no'),de('yes'))#" value="#arguments.fileObjSmall#">,
		<cfqueryparam cfsqltype="cf_sql_blob"  null="#iif(isBinary(arguments.fileObjMedium),de('no'),de('yes'))#" value="#arguments.fileObjMedium#">
		</cfif>
		)	
		</cfquery>
		
		<cfset variables.pluginManager.announceEvent("onFileCache", pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onAfterFileCache",pluginEvent)>
		<cfreturn fileid />
</cffunction>

<cffunction name="deleteVersion" returntype="void" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tfiles set deleted=1 where fileid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>
	
</cffunction>

<cffunction name="deleteAll" returntype="void" access="public" output="false">
		<cfargument name="contentID" type="string" required="yes"/>
		<cfset var rs='' />
			
		<cfquery datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tfiles set deleted=1 where contentid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#">
		</cfquery>
	
</cffunction>

<cffunction name="read" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt,image FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>
		
		<cfreturn rs />
	
</cffunction>

<cffunction name="readAll" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT * FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>
		
		<cfreturn rs />
	
</cffunction>

<cffunction name="readMeta" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt  FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
		</cfquery>
		
		<cfreturn rs />
	
</cffunction>

<cffunction name="readSmall" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt, imageSmall  FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#"> and imageSmall is not null
		</cfquery>
		
		<cfreturn rs />
	
</cffunction>

<cffunction name="readMedium" returntype="query" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfset var rs=""/>
		<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT fileID, contentID, siteID, moduleID, filename, fileSize, contentType, contentSubType, fileExt, imageMedium  FROM tfiles where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#"> and imageMedium is not null
		</cfquery>
		
		<cfreturn rs />
	
</cffunction>

<cffunction name="deleteIfNotUsed" returntype="void" access="public" output="false">
		<cfargument name="fileID" type="any" required="yes"/>
		<cfargument name="baseID" type="any" required="yes"/>
		<cfset var rs1 = "" />
		<cfset var rs2 = "" />
		<cfset var rs3 = "" />
		<cfset var rs4 = "" />
		
		<cfquery name="rs1" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT fileId FROM tcontent where fileid= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#"> and contenthistId <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseID#">
		</cfquery>
		
		<cfquery name="rs2" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT attributeValue FROM tclassextenddata where attributeValue like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#"> and baseId <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseID#">
		</cfquery>
		
		<cfquery name="rs3" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT attributeValue FROM tclassextenddatauseractivity where attributeValue like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#"> and baseId <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseID#">
		</cfquery>
		
		<cfquery name="rs4" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT photoFileID FROM tusers where photoFileID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#"> and userId <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseID#">
		</cfquery>
		
		<cfif not rs1.recordcount and not rs2.recordcount and not rs3.recordcount and not rs4.recordcount>
			<cfset deleteVersion(arguments.fileID) />
		</cfif>
	
</cffunction>

<cffunction name="purgeDeleted" output="false">
<cfset var rs="">
	
<cflock type="exclusive" name="purgingDeletedFile" timeout="1000">
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select fileID from tfiles where deleted=1 
	</cfquery>
	
	<cfloop query="rs">
		<cfset deleteCachedFile(rs.fileID)>
	</cfloop>
	
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	delete from tfiles where deleted=1 
	</cfquery>
</cflock>

</cffunction>

<cffunction name="restoreVersion" output="false">
	<cfargument name="fileID">
	<cfquery name="rs" datasource="#variables.dsn#"  username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tfiles set deleted=0 where fileID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fileID#">
	</cfquery>
</cffunction>

<cffunction name="deleteCachedFile" returntype="void" access="public">
<cfargument name="fileID" type="string" required="yes"/>
<cfset var delim=variables.configBean.getFileDelim() />
<cfset var rsFile=readMeta(arguments.fileID) />
<cfset var pluginEvent = createObject("component","mura.event") />
<cfset var data=arguments />

		<cfset data.siteID=rsFile.siteID />
		<cfset data.rsFile=rsFile />
		<cfset pluginEvent.init(data)>
		
		<cfset variables.pluginManager.announceEvent("onFileCacheDelete",pluginEvent)>
		<cfset variables.pluginManager.announceEvent("onBeforeFileCacheDelete",pluginEvent)>
		
		<cfswitch expression="#variables.configBean.getFileStore()#">
		<cfcase value="fileDir">
		<cftry>
		<cffile action="delete"  file="#application.configBean.getFileDir()##delim##rsFile.siteid##delim#cache#delim#file#delim##arguments.fileID#.#rsFile.fileExt#" >
		<cfcatch></cfcatch>
		</cftry>
		
		<cftry>
		<cffile action="delete"  file="#application.configBean.getFileDir()##delim##rsFile.siteid##delim#cache#delim#file#delim##arguments.fileID#_small.#rsFile.fileExt#" >
		<cfcatch></cfcatch>
		</cftry>
		
		<cftry>
		<cffile action="delete"  file="#application.configBean.getFileDir()##delim##rsFile.siteid##delim#cache#delim#file#delim##arguments.fileID#_medium.#rsFile.fileExt#" >
		<cfcatch></cfcatch>
		</cftry>
		</cfcase>
		
		<cfcase value="s3">
		<cfset variables.s3.deleteS3File(variables.bucket,'#rsFile.siteID#/#arguments.fileid#.#rsFile.fileExt#') />
				<cfif listFindNoCase("png,gif,jpg,jpeg",rsFile.fileExt)>
					<cfset variables.s3.deleteS3File(variables.bucket,'#rsFile.siteID#/#arguments.fileid#_small.#rsFile.fileExt#') />
					<cfset variables.s3.deleteS3File(variables.bucket,'#rsFile.siteID#/#arguments.fileid#_medium.#rsFile.fileExt#') />
				<cfelseif rsFile.fileEXT eq "flv">
					<cfset variables.s3.deleteS3File(variables.bucket,'#rsFile.siteID#/#arguments.fileid#_small.jpg') />
					<cfset variables.s3.deleteS3File(variables.bucket,'#rsFile.siteID#/#arguments.fileid#_medium.jpg') />
				</cfif>
		</cfcase>
		
		</cfswitch>
		
		<cfset variables.pluginManager.announceEvent("onAfterFileCacheDelete",pluginEvent)>
</cffunction>

</cfcomponent>