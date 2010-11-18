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

	<cffunction name="update" returntype="void">
		<cfargument name="find" type="string" default="" required="true">
		<cfargument name="replace" type="string"  default="" required="true">
		<cfargument name="datasource" type="string"  default="#application.configBean.getDatasource()#" required="true">
		
		<cfset var newBody=""/>
		<cfset var newSummary=""/>
		<cfset var rs="">
		<cfif len(arguments.find)>
			<cfquery datasource="#arguments.datasource#" name="rs">
				select contenthistid, body from tcontent where body like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.find#%"/>
			</cfquery>
		
			<cfloop query="rs">
				<cfset newbody=replace(BODY,"#arguments.find#","#arguments.replace#","ALL")>
				<cfquery datasource="#arguments.datasource#">
					update tcontent set body=<cfqueryparam value="#newBody#" cfsqltype="cf_sql_longvarchar" > where contenthistid='#contenthistid#'
				</cfquery>
			</cfloop>
			
			<cfquery datasource="#arguments.datasource#" name="rs">
				select contenthistid, summary from tcontent where summary like '%#arguments.find#%'
			</cfquery>
			
			<cfloop query="rs">
				<cfset newSummary=replace(summary,"#arguments.find#","#arguments.replace#","ALL")>
				<cfquery datasource="#arguments.datasource#">
					update tcontent set summary=<cfqueryparam value="#newSummary#" cfsqltype="cf_sql_longvarchar" > where contenthistid='#contenthistid#'
				</cfquery>
			</cfloop> 	
		</cfif>
	</cffunction>
	
	<cffunction name="getToWork" returntype="void">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="mode" type="string" default="publish" required="true">
		<cfargument name="keyFactory" type="any" required="true">
		<cfargument name="pushMode" type="string" default="full" required="true">
		<cfargument name="lastDeployment" default="" required="true">
		<cfargument name="rsDeleted" required="true" default="#queryNew('objectID')#">	
		<cfset var keys=arguments.keyFactory/>
		<cfset var rsContentNew=""/>
		<cfset var rsContent=""/>
		<cfset var rsContentObjects=""/>
		<cfset var rsContentTags=""/>
		<cfset var rsSystemObjects=""/>
		<cfset var rstpermissions=""/>
		<cfset var rsSettings=""/>
		<cfset var rstadcampaigns=""/>
		<cfset var rstadcreatives=""/>
		<cfset var rstadipwhitelist=""/>
		<cfset var rstadzones=""/>
		<cfset var rstadzonesnew=""/>
		<cfset var rstadplacements=""/>
		<cfset var rstadplacementdetails=""/>
		<cfset var rstadplacementcategories=""/>
		<cfset var rstcontentcategoryassign=""/>
		<cfset var rstcontentfeeds=""/>
		<cfset var rstcontentfeedsnew=""/>
		<cfset var rstcontentfeeditems=""/>
		<cfset var rstcontentfeedadvancedparams=""/>
		<cfset var rstcontentrelated=""/>
		<cfset var rsMailinglist=""/>
		<cfset var rsMailinglistnew=""/>
		<cfset var rsFiles=""/>
		<cfset var rstcontentcategories=""/>
		<cfset var rstcontentcategoriesnew=""/>
		<cfset var rstcontentcomments=""/>
		<cfset var rstcontentratings=""/>
		<cfset var rstusersinterests=""/>
		<cfset var rstclassextend=""/>
		<cfset var rstclassextendsets=""/>
		<cfset var rstclassextendattributes=""/>
		<cfset var rstclassextenddata=""/>
		<cfset var getNewID=""/>
		<cfset var rstpluginscripts=""/>
		<cfset var rstplugindisplayobjects=""/>
		<cfset var rstpluginsettings=""/>
		<cfset var rsCheck="">		
		
			<!--- pushed tables --->
		
			<!--- tcontent --->
			<cfif arguments.pushMode eq "UpdatesOnly">
				<cfquery datasource="#arguments.fromDSN#" name="rsContentNew">
					select contentID from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/> and active = 1 and lastUpdate >= #createODBCDateTime(lastDeployment)#
				</cfquery>
			</cfif>
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsContentNew.recordcount or rsDeleted.recordcount>
						and (
						<cfif rsContentNew.recordcount>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsContentNew.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rsContentNew.recordcount>or</cfif>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsContent">
				select * from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/> and active = 1
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsContentNew.recordcount>
						and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsContentNew.contentID)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rsContent">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontent (Active,Approved,audience,Body,ContentHistID,ContentID,Credits,Display,DisplayStart,DisplayStop,featureStart,featureStop,FileID,Filename,forceSSL,inheritObjects,isFeature,IsLocked,IsNav,keyPoints,lastUpdate,lastUpdateBy,lastUpdateByID,MenuTitle,MetaDesc,MetaKeyWords,moduleAssign,ModuleID,nextN,Notes,OrderNo,ParentID,displayTitle,ReleaseDate,RemoteID,RemotePubDate,RemoteSource,RemoteSourceURL,RemoteURL,responseChart,responseDisplayFields,responseMessage,responseSendTo,Restricted,RestrictGroups,searchExclude,SiteID,sortBy,sortDirection,Summary,Target,TargetParams,Template,Title,Type,subType,Path,tags,doCache,created,urltitle,htmltitle,mobileExclude)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Active),de(Active),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Approved),de(Approved),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(audience neq '',de('no'),de('yes'))#" value="#audience#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Body neq '',de('no'),de('yes'))#" value="#Body#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Credits neq '',de('no'),de('yes'))#" value="#Credits#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Display),de(Display),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(DisplayStart),de('no'),de('yes'))#" value="#DisplayStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(DisplayStop),de('no'),de('yes'))#" value="#DisplayStop#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStart),de('no'),de('yes'))#" value="#featureStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStop),de('no'),de('yes'))#" value="#featureStop#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(FileID neq '',de('no'),de('yes'))#" value="#keys.get(fileID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Filename neq '',de('no'),de('yes'))#" value="#Filename#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(forceSSL),de(forceSSL),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(inheritObjects neq '',de('no'),de('yes'))#" value="#inheritObjects#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isFeature),de(isFeature),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(IsLocked),de(IsLocked),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(IsNav),de(IsNav),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(keyPoints neq '',de('no'),de('yes'))#" value="#keyPoints#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateByID neq '',de('no'),de('yes'))#" value="#lastUpdateByID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(MenuTitle neq '',de('no'),de('yes'))#" value="#MenuTitle#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(MetaDesc neq '',de('no'),de('yes'))#" value="#MetaDesc#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(MetaKeyWords neq '',de('no'),de('yes'))#" value="#MetaKeyWords#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(moduleAssign neq '',de('no'),de('yes'))#" value="#moduleAssign#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ModuleID neq '',de('no'),de('yes'))#" value="#ModuleID#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(nextN),de(nextN),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Notes neq '',de('no'),de('yes'))#" value="#Notes#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(OrderNo),de(OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(parentID)#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayTitle),de(displayTitle),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(ReleaseDate),de('no'),de('yes'))#" value="#ReleaseDate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RemoteID neq '',de('no'),de('yes'))#" value="#RemoteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RemotePubDate neq '',de('no'),de('yes'))#" value="#RemotePubDate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RemoteSource neq '',de('no'),de('yes'))#" value="#RemoteSource#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RemoteSourceURL neq '',de('no'),de('yes'))#" value="#RemoteSourceURL#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RemoteURL neq '',de('no'),de('yes'))#" value="#RemoteURL#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(responseChart),de(responseChart),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(responseDisplayFields neq '',de('no'),de('yes'))#" value="#responseDisplayFields#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(responseMessage neq '',de('no'),de('yes'))#" value="#responseMessage#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(responseSendTo neq '',de('no'),de('yes'))#" value="#responseSendTo#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(Restricted),de(Restricted),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(RestrictGroups neq '',de('no'),de('yes'))#" value="#RestrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(searchExclude),de(searchExclude),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortBy neq '',de('no'),de('yes'))#" value="#sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortDirection neq '',de('no'),de('yes'))#" value="#sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Summary neq '',de('no'),de('yes'))#" value="#Summary#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Target neq '',de('no'),de('yes'))#" value="#Target#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(TargetParams neq '',de('no'),de('yes'))#" value="#TargetParams#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Template neq '',de('no'),de('yes'))#" value="#Template#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Title neq '',de('no'),de('yes'))#" value="#Title#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Type neq '',de('no'),de('yes'))#" value="#Type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(subType neq '',de('no'),de('yes'))#" value="#subType#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Path neq '',de('no'),de('yes'))#" value="#Path#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Tags neq '',de('no'),de('yes'))#" value="#Tags#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(doCache),de(doCache),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(created),de('no'),de('yes'))#" value="#created#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(urlTitle neq '',de('no'),de('yes'))#" value="#urltitle#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(htmltitle neq '',de('no'),de('yes'))#" value="#htmltitle#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(mobileExclude),de(mobileExclude),de(0))#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentobjects --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsContentNew.recordcount or rsDeleted.recordcount>
						and (
						<cfif rsContentNew.recordcount>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsContentNew.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rsContentNew.recordcount>or</cfif>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsContentObjects">
				select * from tcontentobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsContentNew.recordcount>
						and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsContentNew.contentID)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rsContentObjects">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentobjects (ColumnID,ContentHistID,ContentID,Name,Object,ObjectID,OrderNo,SiteID,params)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(ColumnID),de(ColumnID),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Name neq '',de('no'),de('yes'))#" value="#Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Object neq '',de('no'),de('yes'))#" value="#Object#">,
					<cfif arguments.mode eq "copy" and arguments.fromDSN eq arguments.toDSN>
						<cfif listFindNoCase("plugin,adzone", object)>
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ObjectID neq '',de('no'),de('yes'))#" value="#objectID#">,
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ObjectID neq '',de('no'),de('yes'))#" value="#keys.get(objectID)#">,
						</cfif>
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ObjectID neq '',de('no'),de('yes'))#" value="#keys.get(objectID)#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(OrderNo),de(OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(params neq '',de('no'),de('yes'))#" value="#params#">
					)
				</cfquery>
			</cfloop>
			
			<!--- tcontenttags --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontenttags where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsContentNew.recordcount or rsDeleted.recordcount>
					and (
						<cfif rsContentNew.recordcount>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsContentNew.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rsContentNew.recordcount>or</cfif>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsContentTags">
				select * from tcontenttags where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsContentNew.recordcount>
						and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsContentNew.contentID)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rsContentTags">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontenttags (ContentHistID,ContentID,siteID,tag)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(tag neq '',de('no'),de('yes'))#" value="#tag#">
					)
				</cfquery>
			</cfloop>
			
			<!--- tsystemobjects--->
			<cfif arguments.pushMode eq "full">
			<cfquery datasource="#arguments.toDSN#">
				delete from tsystemobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsSystemObjects">
				select * from tsystemobjects where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
			</cfquery>
			<cfloop query="rsSystemObjects">
				<cfquery datasource="#arguments.toDSN#">
					insert into tsystemobjects (Name,Object,OrderNo,SiteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Name neq '',de('no'),de('yes'))#" value="#Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Object neq '',de('no'),de('yes'))#" value="#Object#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(OrderNo),de(OrderNo),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR"  value="#arguments.toSiteID#">
					)
				</cfquery>
			</cfloop>
			</cfif>
			<!--- tpermissions--->
			<cfquery datasource="#arguments.toDSN#">
				delete from tpermissions where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsTPermissions">
				select * from tpermissions where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
			</cfquery>
			<cfloop query="rsTPermissions">
				<cfquery datasource="#arguments.toDSN#">
					insert into tpermissions (contentID,groupID,Type,SiteID)
					values
					(
					<cfif type eq "module" or not find("-",contentID)>
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#contentID#">
					<cfelse>
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">
					</cfif>,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#groupID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">
					)
				</cfquery>
			</cfloop>
			
			<cfif not (arguments.mode eq "copy" and arguments.toDSN eq arguments.fromDSN)>
				<!--- tadcampaigns --->
				<cfquery datasource="#arguments.fromDSN#" name="rsSettings">
					select advertiserUserPoolID from tsettings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfquery datasource="#arguments.fromDSN#" name="rstadcampaignsnew">
					select campaignID from tadcampaigns
					where userID in 
					(select userID from tusers where
					siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
					siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPublicUserPoolID()#') 
					and lastUpdate >= #createODBCDateTime(lastDeployment)#
					</cfquery>
				</cfif>
				<cfquery datasource="#arguments.toDSN#">
					delete from tadcampaigns
					where userID in 
					(select userID from tusers where
					siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
					siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPublicUserPoolID()#')
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif rstadcampaignsnew.recordcount or rsDeleted.recordcount>
							and (
							<cfif rstadcampaignsnew.recordcount>
								campaignID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadcampaignsnew.campaignID)#">)
							</cfif>
							<cfif rsDeleted.recordcount>
								<cfif rstadcampaignsnew.recordcount>or</cfif>
								campaignID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
							</cfif>
							)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#" name="rstadcampaigns">
					select * from tadcampaigns
					where userID in 
					(select userID from tusers where
					siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
					siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPublicUserPoolID()#')
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif rstadcampaignsnew.recordcount>
							and campaignID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadcampaignsnew.campaignID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				
				<cfloop query="rstadcampaigns">
					<cfquery name="rsCheck" datasource="#arguments.toDSN#">
						select userID from tusers where userID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(userID)#">
					</cfquery>
					<!--- only add the campaign if the user exists--->
					<cfif rsCheck.recordcount>
					<cfquery datasource="#arguments.toDSN#">
						insert into tadcampaigns (campaignID,dateCreated,endDate,isActive,lastUpdate,lastUpdateBy,name,notes,startDate,userID)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(campaignID)#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(endDate),de('no'),de('yes'))#" value="#endDate#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
						<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(startDate),de('no'),de('yes'))#" value="#startDate#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(userID neq '',de('no'),de('yes'))#" value="#userID#">
						)
					</cfquery>
					</cfif>
				</cfloop>
				<!--- tadcreatives --->
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfquery datasource="#arguments.fromDSN#" name="tadcreativesnew">
						select creativeID from tadcreatives 
						where userID in 
						(select userID from tusers where
						siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
						siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPublicUserPoolID()#')
						and lastUpdate >= #createODBCDateTime(lastDeployment)#
					</cfquery>
				</cfif>
				<cfquery datasource="#arguments.toDSN#">
					delete from tadcreatives 
					where userID in 
					(select userID from tusers where
					siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
					siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPublicUserPoolID()#')
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif tadcreativesnew.recordcount or rsDeleted.recordcount>
							and (
							<cfif tadcreativesnew.recordcount>
								creativeID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(tadcreativesnew.creativeID)#">)
							</cfif>
							<cfif rsDeleted.recordcount>
								<cfif tadcreativesnew.recordcount>or</cfif>
								creativeID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
							</cfif>
							)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#" name="rstadcreatives">
					select * from tadcreatives
					where userID in 
					(select userID from tusers where
					siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPrivateUserPoolID()#' or
					siteid = '#application.settingsManager.getSite(rsSettings.advertiserUserPoolID).getPublicUserPoolID()#')
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif tadcreativesnew.recordcount>
							and creativeID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(tadcreativesnew.creativeID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfloop query="rstadcreatives">
					<cfquery name="rsCheck" datasource="#arguments.toDSN#">
						select userID from tusers where userID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(userID)#">
					</cfquery>
					<!--- only add the campaign if the user exists--->
					<cfif rsCheck.recordcount>
					<cfquery datasource="#arguments.toDSN#">
						insert into tadcreatives (altText,creativeID,creativeType,dateCreated,fileID,height,isActive,lastUpdate,lastUpdateBy,mediaType,name,notes,redirectURL,textBody,userID,width,target)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(altText neq '',de('no'),de('yes'))#" value="#altText#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(creativeID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(creativeType neq '',de('no'),de('yes'))#" value="#creativeType#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(fileID neq '',de('no'),de('yes'))#" value="#keys.get(fileID)#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(height),de(height),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(mediaType neq '',de('no'),de('yes'))#" value="#mediaType#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
						<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(redirectURL neq '',de('no'),de('yes'))#" value="#redirectURL#">,
						<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(textBody neq '',de('no'),de('yes'))#" value="#textBody#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(userID neq '',de('no'),de('yes'))#" value="#userID#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(width),de(width),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(target neq '',de('no'),de('yes'))#" value="#target#">
						)				
					</cfquery>
					</cfif>
				</cfloop>
				<!--- tadipwhitelist --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tadipwhitelist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#" name="rstadipwhitelist">
					select * from tadipwhitelist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
				<cfloop query="rstadipwhitelist">
					<cfquery datasource="#arguments.toDSN#">
						insert into tadipwhitelist (IP,siteID)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(IP neq '',de('no'),de('yes'))#" value="#IP#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">
						)
					</cfquery>
				</cfloop>
				<!--- tadzones --->
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfquery datasource="#arguments.fromDSN#" name="rstadzonesnew">
						select adzoneID from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
						and lastUpdate >= #createODBCDateTime(lastDeployment)#
					</cfquery>
				</cfif>
				<cfquery datasource="#arguments.toDSN#">
					delete from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif rstadzonesnew.recordcount or rsDeleted.recordcount>
							and (
							<cfif rstadzonesnew.recordcount>
								adzoneID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadzonesnew.adzoneID)#">)
							</cfif>
							<cfif rsDeleted.recordcount>
								<cfif rstadzonesnew.recordcount>or</cfif>
								adzoneID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
							</cfif>
							)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#" name="rstadzones">
					select * from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif rstadzonesnew.recordcount>
							and adzoneID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadzonesnew.adzoneID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfloop query="rstadzones">
					<cfquery datasource="#arguments.toDSN#">
						insert into tadzones (adZoneID,creativeType,dateCreated,height,isActive,lastUpdate,lastUpdateBy,name,notes,siteID,width)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(adZoneID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(creativeType neq '',de('no'),de('yes'))#" value="#creativeType#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(height),de(height),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
						<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeid#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(width),de(width),de(0))#">
						)
					</cfquery>
				</cfloop>
				<!--- tadplacements --->
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfquery datasource="#arguments.fromDSN#" name="rstadplacementsnew">
						select placementID from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>)
						and lastUpdate >= #createODBCDateTime(lastDeployment)#
					</cfquery>
				</cfif>
				<cfquery datasource="#arguments.toDSN#">
					delete from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif rstadplacementsnew.recordcount or rsDeleted.recordcount>
							and (
							<cfif rstadplacementsnew.recordcount>
								placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacementsnew.placementID)#">)
							</cfif>
							<cfif rsDeleted.recordcount>
								<cfif rstadplacementsnew.recordcount>or</cfif>
								placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
							</cfif>
							)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#" name="rstadplacements">
					select * from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>)
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif rstadplacementsnew.recordcount>
							and placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacementsnew.placementID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfloop query="rstadplacements">
					<cfquery datasource="#arguments.toDSN#">
						insert into tadplacements (adZoneID,billable,budget,campaignID,costPerClick,costPerImp,creativeID,dateCreated,endDate,isActive,isExclusive,lastUpdate,lastUpdateBy,notes,placementID,startDate,hasCategories)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(adZoneID neq '',de('no'),de('yes'))#" value="#keys.get(adZoneID)#">,
						<cfqueryparam cfsqltype="cf_sql_DECIMAL" null="no" value="#iif(isNumeric(billable),de(billable),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(budget),de(budget),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(campaignID neq '',de('no'),de('yes'))#" value="#keys.get(campaignID)#">,
						<cfqueryparam cfsqltype="cf_sql_DECIMAL" null="no" value="#iif(isNumeric(costPerClick),de(costPerClick),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_DECIMAL" null="no" value="#iif(isNumeric(costPerImp),de(costPerImp),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(creativeID neq '',de('no'),de('yes'))#" value="#keys.get(creativeID)#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(endDate),de('no'),de('yes'))#" value="#endDate#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isExclusive),de(isExclusive),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
						<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(placementID)#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(startDate),de('no'),de('yes'))#" value="#startDate#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(hasCategories),de(hasCategories),de(0))#">
						)
					</cfquery>
				</cfloop>
				
				<!--- tadplacementdetails --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tadplacementdetails where placementid in (select placementid from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>))
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif rstadplacementsnew.recordcount or rsDeleted.recordcount>
							and (
							<cfif rstadplacementsnew.recordcount>
								placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacementsnew.placementID)#">)
							</cfif>
							<cfif rsDeleted.recordcount>
								<cfif rstadplacementsnew.recordcount>or</cfif>
								placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
							</cfif>
							)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#" name="rstadplacementdetails">
					select * from tadplacementdetails where placementid in (select placementid from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>))
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif rstadplacementsnew.recordcount>
							and placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacementsnew.placementID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfloop query="rstadplacementdetails">
					<cfquery datasource="#arguments.toDSN#">
						insert into tadplacementdetails (placementID, placementType, placementValue)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(placementID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(placementType neq '',de('no'),de('yes'))#" value="#placementType#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(placementValue),de(placementValue),de(0))#">
						)
					</cfquery>
				</cfloop>
			</cfif>
			
			<!--- rstadplacementcategories --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tadplacementcategoryassign where placementid in (select placementid from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>))
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif rstadplacementsnew.recordcount or rsDeleted.recordcount>
							and (
							<cfif rstadplacementsnew.recordcount>
								placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacementsnew.placementID)#">)
							</cfif>
							<cfif rsDeleted.recordcount>
								<cfif rstadplacementsnew.recordcount>or</cfif>
								placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
							</cfif>
							)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#" name="rstadplacementcategories">
					select * from tadplacementcategoryassign where placementid in (select placementid from tadplacements where adzoneid in (select adzoneid from tadzones where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>))
					<cfif arguments.pushMode eq "UpdatesOnly">
						<cfif rstadplacementsnew.recordcount>
							and placementID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstadplacementsnew.placementID)#">)
						<cfelse>
							and 0=1
						</cfif>
					</cfif>
				</cfquery>
				<cfloop query="rstadplacementcategories">
					<cfquery datasource="#arguments.toDSN#">
						insert into tadplacementcategoryassign (placementID, categoryID)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(placementID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(categoryID)#">
						)
					</cfquery>
				</cfloop>
			<!--- tcontentcategoryassign --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentcategoryassign where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsContentNew.recordcount or rsDeleted.recordcount>
						and (
						<cfif rsContentNew.recordcount>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsContentNew.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentfeedsnew.recordcount>or</cfif>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentcategoryassign">
				select * from tcontentcategoryassign where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsContentNew.recordcount>
						and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsContentNew.contentID)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rstcontentcategoryassign">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentcategoryassign (categoryID,contentHistID,contentID,featureStart,featureStop,isFeature,orderno,siteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(categoryID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStart),de('no'),de('yes'))#" value="#featureStart#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(featureStop),de('no'),de('yes'))#" value="#featureStop#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isFeature),de(isFeature),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(orderno),de(orderno),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentfeeds --->
			<cfif arguments.pushMode eq "UpdatesOnly">
				<cfquery datasource="#arguments.fromDSN#" name="rstcontentfeedsnew">
					select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/> and lastUpdate >= #createODBCDateTime(lastDeployment)#
				</cfquery>
			</cfif>
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rstcontentfeedsnew.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontentfeedsnew.recordcount>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeedsnew.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentfeedsnew.recordcount>or</cfif>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentfeeds">
				select * from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rstcontentfeedsnew.recordcount>
						and feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeedsnew.feedID)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rstcontentfeeds">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentfeeds (allowHTML,channelLink,dateCreated,description,feedID,isActive,isDefault,isFeaturesOnly,isPublic,lang,lastUpdate,lastUpdateBy,maxItems,name,parentID,restricted,restrictGroups,siteID,Type,version,sortBy,sortDirection,nextN,displayName,displayRatings,displayComments,altname,remoteID,remoteSourceURL,remotePubDate)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(allowHTML),de(allowHTML),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(channelLink neq '',de('no'),de('yes'))#" value="#channelLink#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(description neq '',de('no'),de('yes'))#" value="#description#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(feedID)#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isDefault),de(isDefault),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isFeaturesOnly),de(isFeaturesOnly),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isPublic),de(isPublic),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lang neq '',de('no'),de('yes'))#" value="#lang#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(maxItems),de(maxItems),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" null="#iif(parentID neq '',de('no'),de('yes'))#" value="#keys.get(parentID)#">,
					<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(restricted),de(restricted),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(restrictGroups neq '',de('no'),de('yes'))#" value="#restrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteid#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Type neq '',de('no'),de('yes'))#" value="#Type#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(version neq '',de('no'),de('yes'))#" value="#version#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortBy neq '',de('no'),de('yes'))#" value="#sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortDirection neq '',de('no'),de('yes'))#" value="#sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(nextN),de(nextN),de(20))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayName),de(displayName),de(1))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayRatings),de(displayRatings),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(displayComments),de(displayComments),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(altname neq '',de('no'),de('yes'))#" value="#altname#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteid neq '',de('no'),de('yes'))#" value="#remoteid#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteSourceURL neq '',de('no'),de('yes'))#" value="#remoteSourceURL#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(remotePubDate neq '',de('no'),de('yes'))#" value="#remotePubDate#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentfeeditems --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentfeeditems where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rstcontentfeedsnew.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontentfeedsnew.recordcount>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeedsnew.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentfeedsnew.recordcount>or</cfif>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentFeedItems">
				select * from tcontentfeeditems where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>)
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rstcontentfeedsnew.recordcount>
						and feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeedsnew.feedID)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rstcontentFeedItems">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentfeeditems (feedID,itemID,type)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(feedID)#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(itemID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">
					)
				</cfquery>
			</cfloop>
		
			<!--- tcontentfeedadvancedparams --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentfeedadvancedparams where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rstcontentfeedsnew.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontentfeedsnew.recordcount>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeedsnew.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentfeedsnew.recordcount>or</cfif>
							feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentFeedAdvancedParams">
				select * from tcontentfeedadvancedparams where feedID in (select feedID from tcontentfeeds where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>)
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rstcontentfeedsnew.recordcount>
						and feedID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentfeedsnew.feedID)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rstcontentFeedAdvancedParams">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentfeedadvancedparams (paramID,feedID,param,relationship,field,dataType,<cfif application.configBean.getDbType() eq "mysql">`condition`<cfelse>condition</cfif>,criteria)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(paramID)#">,
					<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(feedID)#">,
					<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isNumeric(param),de('no'),de('yes'))#" value="#param#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(relationship neq '',de('no'),de('yes'))#" value="#relationship#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(field neq '',de('no'),de('yes'))#" value="#field#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(dataType neq '',de('no'),de('yes'))#" value="#dataType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(condition neq '',de('no'),de('yes'))#" value="#condition#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(criteria neq '',de('no'),de('yes'))#" value="#criteria#">
					)
				</cfquery>
			</cfloop>
			<!--- tcontentrelated --->
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentrelated where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsContentNew.recordcount or rsDeleted.recordcount>
						and (
						<cfif rsContentNew.recordcount>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsContentNew.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentfeedsnew.recordcount>or</cfif>
							contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentrelated">
				select * from tcontentrelated where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsContentNew.recordcount>
						and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsContentNew.contentID)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rstcontentrelated">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentrelated (contentHistID,contentID,relatedID,siteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentHistID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(relatedID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">
					)
				</cfquery>
			</cfloop>
			<!--- tmailinglist --->
			<cfif arguments.pushMode eq "UpdatesOnly">
				<cfquery datasource="#arguments.fromDSN#" name="rsMailingListNew">
					select mlid from tmailinglist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/> and lastUpdate >= #createODBCDateTime(lastDeployment)#
				</cfquery>
			</cfif>
			<cfquery datasource="#arguments.toDSN#" name="rsMailingList">
				delete from tmailinglist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsMailingListNew.recordcount or rsDeleted.recordcount>
						and (
						<cfif rsMailingListNew.recordcount>
							mlid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsMailingListNew.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rsMailingListNew.recordcount>or</cfif>
							mlid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rsMailingList">
				select * from tmailinglist where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rsMailingListNew.recordcount>
						and mlid in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsMailingListNew.mlid)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rsMailingList">
				<cfquery datasource="#arguments.toDSN#">
					insert into tmailinglist (Description,isPublic,isPurge,LastUpdate,MLID,Name,SiteID)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Description neq '',de('no'),de('yes'))#" value="#Description#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isPublic),de(isPublic),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isPurge),de(isPurge),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(LastUpdate),de('no'),de('yes'))#" value="#LastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(MLID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(Name neq '',de('no'),de('yes'))#" value="#Name#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">
					)
				</cfquery>
			</cfloop>
			<!--- tfiles --->
			<cfif arguments.pushMode neq "changesOnly">
				<cfquery datasource="#arguments.toDSN#">
					delete from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and moduleid <> '00000000000000000000000000000000004'
				</cfquery>
			</cfif>
			<cfquery datasource="#arguments.fromDSN#" name="rsFiles">
				select * from tfiles where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				and moduleid <> '00000000000000000000000000000000004'
				<cfif arguments.pushMode eq "changesOnly">
					created >= #createODBCDateTime(created)#
				</cfif>
			</cfquery>
			<cfloop query="rsFiles">
				<cfquery datasource="#arguments.toDSN#">
					insert into tfiles (contentID,contentSubType,contentType,fileExt,fileID,filename,fileSize,image,imageMedium,imageSmall,moduleID,siteID,created)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentID neq '',de('no'),de('yes'))#" value="#keys.get(contentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentSubType neq '',de('no'),de('yes'))#" value="#contentSubType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentType neq '',de('no'),de('yes'))#" value="#contentType#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(fileExt neq '',de('no'),de('yes'))#" value="#fileExt#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(fileID neq '',de('no'),de('yes'))#" value="#keys.get(fileID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(filename neq '',de('no'),de('yes'))#" value="#filename#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(fileSize),de(fileSize),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_BLOB" null="#iif(toBase64(image) eq '',de('yes'),de('no'))#" value="#image#">,
					<cfqueryparam cfsqltype="cf_sql_BLOB" null="#iif(toBase64(imageMedium) eq '',de('yes'),de('no'))#" value="#imageMedium#">,
					<cfqueryparam cfsqltype="cf_sql_BLOB" null="#iif(toBase64(imageSmall) eq '',de('yes'),de('no'))#" value="#imageSmall#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(moduleID neq '',de('no'),de('yes'))#" value="#moduleID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(created),de('no'),de('yes'))#" value="#created#">
					)
				</cfquery>
			</cfloop>
			
			<!--- tcontentcategories --->
			<cfif arguments.pushMode eq "UpdatesOnly">
				<cfquery datasource="#arguments.fromDSN#" name="rstcontentcategoriesnew">
					select categoryID from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/> and lastUpdate >= #createODBCDateTime(lastDeployment)#
				</cfquery>
			</cfif>
			<cfquery datasource="#arguments.toDSN#">
				delete from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rstcontentcategoriesnew.recordcount or rsDeleted.recordcount>
						and (
						<cfif rstcontentcategoriesnew.recordcount>
							categoryID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentcategoriesnew.contentID)#">)
						</cfif>
						<cfif rsDeleted.recordcount>
							<cfif rstcontentcategoriesnew.recordcount>or</cfif>
							categoryID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rsDeleted.objectID)#">)
						</cfif>
						)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfquery datasource="#arguments.fromDSN#" name="rstcontentcategories">
				select * from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				<cfif arguments.pushMode eq "UpdatesOnly">
					<cfif rstcontentcategoriesnew.recordcount>
						and categoryID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(rstcontentcategoriesnew.categoryID)#">)
					<cfelse>
						and 0=1
					</cfif>
				</cfif>
			</cfquery>
			<cfloop query="rstcontentcategories">
				<cfquery datasource="#arguments.toDSN#">
					insert into tcontentcategories (categoryID,dateCreated,isActive,isInterestGroup,isOpen,lastUpdate,lastUpdateBy,name,notes,parentID,restrictGroups,siteID,sortBy,sortDirection,Path,remoteID,remoteSourceURL,remotePubDate)
					values
					(
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(categoryID)#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(dateCreated),de('no'),de('yes'))#" value="#dateCreated#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isActive),de(isActive),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isInterestGroup),de(isInterestGroup),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(isOpen),de(isOpen),de(0))#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(lastUpdate),de('no'),de('yes'))#" value="#lastUpdate#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(lastUpdateBy neq '',de('no'),de('yes'))#" value="#lastUpdateBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(parentID neq '',de('no'),de('yes'))#" value="#keys.get(parentID)#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(restrictGroups neq '',de('no'),de('yes'))#" value="#restrictGroups#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortBy neq '',de('no'),de('yes'))#" value="#sortBy#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(sortDirection neq '',de('no'),de('yes'))#" value="#sortDirection#">,
					<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(Path neq '',de('no'),de('yes'))#" value="#Path#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteid neq '',de('no'),de('yes'))#" value="#remoteID#">,
					<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteSourceURL neq '',de('no'),de('yes'))#" value="#remoteSourceURL#">,
					<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(remotePubDate neq '',de('no'),de('yes'))#" value="#remotePubDate#">
					)
				</cfquery>
			</cfloop>
			
			<!--- synced tables--->
			<cfif arguments.mode eq "publish">
				<cfset arguments.rsContentNew=rsContentNew>
				<cfset getToWorkPublish(argumentCollection=arguments)>
			<cfelseif arguments.mode eq "copy">
				<cfset getToWorkCopy(argumentCollection=arguments)>
			</cfif>
			<cfif not (arguments.mode eq "copy" and arguments.toDSN eq arguments.fromDSN)>
				<cfset getToWorkCopySameDSN(argumentCollection=arguments)>
			</cfif>
		
	</cffunction>
	
	<cffunction name="getToWorkPublish" returntype="void">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="mode" type="string" default="publish" required="true">
		<cfargument name="keyFactory" type="any" required="true">rsContentNew
		<cfargument name="pushMode" type="any" default="full" required="true">
		<cfargument name="rsContentNew" type="any" required="true">
		<cfargument name="rsDeleted" type="any" required="true">	
		<cfset var keys=arguments.keyFactory/>
		<cfset var rsContent=""/>
		<cfset var rsContentObjects=""/>
		<cfset var rsContentTags=""/>
		<cfset var rsSystemObjects=""/>
		<cfset var rstpermissions=""/>
		<cfset var rsSettings=""/>
		<cfset var rstadcampaigns=""/>
		<cfset var rstadcreatives=""/>
		<cfset var rstadipwhitelist=""/>
		<cfset var rstadzones=""/>
		<cfset var rstadplacements=""/>
		<cfset var rstadplacementdetails=""/>
		<cfset var rstcontentcategoryassign=""/>
		<cfset var rstcontentfeeds=""/>
		<cfset var rstcontentfeeditems=""/>
		<cfset var rstcontentfeedadvancedparams=""/>
		<cfset var rstcontentrelated=""/>
		<cfset var rsMailinglist=""/>
		<cfset var rsFiles=""/>
		<cfset var rstcontentcategories=""/>
		<cfset var rstcontentcomments=""/>
		<cfset var rstcontentratings=""/>
		<cfset var rstusersinterests=""/>
		<cfset var rstclassextend=""/>
		<cfset var rstclassextendsets=""/>
		<cfset var rstclassextendattributes=""/>
		<cfset var rstclassextenddata=""/>
		<cfset var getNewID=""/>
		<cfset var rstpluginscripts=""/>
		<cfset var rstplugindisplayobjects=""/>
		<cfset var rstpluginsettings=""/>
		<cfset var rsRemoteDefinitions=application.configBean.getClassExtensionManager().buildDefinitionsQuery(arguments.toDSN)>		
		<cfset var rsRemoteAttribute="">
		
		<cfif arguments.pushMode eq "Full">
				<!--- tcontentcomments --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tcontentcomments where commentid not in (select commentid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				</cfquery>
				<cfquery datasource="#arguments.toDSN#" name="rstcontentcomments">
					select * from tcontentcomments where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#">
					delete from tcontentcomments where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
				<cfloop query="rstcontentcomments">
					<cfquery datasource="#arguments.fromDSN#">
						insert into tcontentcomments (comments,commentid,contenthistid,contentid,email,entered,ip,isApproved,name,siteid,url,subscribe,parentID,path)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(comments neq '',de('no'),de('yes'))#" value="#comments#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(commentid neq '',de('no'),de('yes'))#" value="#keys.get(commentID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contenthistid neq '',de('no'),de('yes'))#" value="#keys.get(contentHistID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(contentid neq '',de('no'),de('yes'))#" value="#keys.get(contentID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(email neq '',de('no'),de('yes'))#" value="#email#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(entered),de('no'),de('yes'))#" value="#entered#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(ip neq '',de('no'),de('yes'))#" value="#ip#">,
						<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(isApproved),de(isApproved),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.fromsiteid#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(url neq '',de('no'),de('yes'))#" value="#url#">,
						<cfqueryparam cfsqltype="cf_sql_TINYINT" null="no" value="#iif(isNumeric(subscribe),de(subscribe),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(parentID neq '',de('no'),de('yes'))#" value="#parentID#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(path neq '',de('no'),de('yes'))#" value="#path#">
						)
					</cfquery>
				</cfloop>
				<!--- tcontentratings --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tcontentratings where contentid not in (select contentid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				</cfquery>
				<cfquery datasource="#arguments.toDSN#" name="rstcontentRatings">
					select * from tcontentratings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#">
					delete from tcontentratings where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
				<cfloop query="rstcontentRatings">
					<cfquery datasource="#arguments.fromDSN#">
						insert into tcontentratings (contentID,rate,siteID,userID,entered)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_IDSTAMP" value="#keys.get(contentID)#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rate),de(rate),de(0))#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.fromsiteID#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(userID neq '',de('no'),de('yes'))#" value="#keys.get(userID)#">,
						<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(entered),de('no'),de('yes'))#" value="#entered#">
						)
					</cfquery>
				</cfloop>
	
				<!--- tusersinterests --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tusersinterests where categoryid not in (select categoryid from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				</cfquery>
				<cfquery datasource="#arguments.toDSN#" name="rstusersinterests">
					select * from tusersinterests where categoryid in (select categoryid from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>)
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#">
					delete from tusersinterests where categoryid in (select categoryid from tcontentcategories where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>)
				</cfquery>
				<cfloop query="rstusersinterests">
					<cfquery datasource="#arguments.fromDSN#">
						insert into tusersinterests (categoryID,userID)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(categoryID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(userID)#">
						)
					</cfquery>
				</cfloop>
			</cfif>
			
					
				<!--- tclassextenddata --->
				<cfquery datasource="#arguments.toDSN#">
					delete from tclassextenddata 
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and baseID  
						in (select contenthistid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
							<cfif arguments.pushMode eq "UpdatesOnly">
								<cfif arguments.rsContentNew.recordcount or arguments.rsDeleted.recordcount>
									and (
									<cfif arguments.rsContentNew.recordcount>
										contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(arguments.rsContentNew.contentID)#">)
									</cfif>
									<cfif arguments.rsDeleted.recordcount>
										<cfif arguments.rsContentNew.recordcount>or</cfif>
										contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(arguments.rsDeleted.objectID)#">)
									</cfif>
									)
								<cfelse>
									and 0=1
								</cfif>
							</cfif>
							)
				</cfquery>
				
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextenddata">
					select tclassextenddata.baseID, tclassextenddata.attributeID, tclassextenddata.attributeValue, tclassextenddata.siteID, 
					tclassextenddata.stringvalue, tclassextenddata.numericvalue, tclassextenddata.datetimevalue, tclassextenddata.remoteID,
					tclassextendattributes.name
					from tclassextenddata 
					Inner Join tclassextendattributes on (tclassextendattributes.attributeID=tclassextenddata.attributeID)
					where tclassextenddata.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and tclassextenddata.baseID 
						in (
							select contenthistid from tcontent where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
							<cfif arguments.pushMode eq "UpdatesOnly">
								<cfif arguments.rsContentNew.recordcount>
									and contentID in (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#valueList(arguments.rsContentNew.contentID)#">)
								<cfelse>
									and 0=1
								</cfif>
							</cfif>
							)
				</cfquery>
				
				<cfloop query="rstclassextenddata">
					<cfquery name="rsRemoteAttribute" dbtype="query">
					select attributeID from rsRemoteDefinitions 
					where attributename=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rstclassextenddata.name#">
					and siteID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.toSiteID#">
					</cfquery>
					<!--- Only move the data over if the attribute exists --->
					<cfif rsRemoteAttribute.recordcount>
						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextenddata (baseID,attributeID,attributeValue,siteID, stringvalue, numericvalue, datetimevalue, remoteID)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(baseID)#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(rsRemoteAttribute.attributeID),de(rsRemoteAttribute.attributeID),de(0))#">,
							<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(attributeValue neq '',de('no'),de('yes'))#" value="#attributeValue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(stringvalue neq '',de('no'),de('yes'))#" value="#stringvalue#">,
							<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isNumeric(numericvalue),de('no'),de('yes'))#" value="#numericvalue#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(datetimevalue),de('no'),de('yes'))#" value="#datetimevalue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteID neq '',de('no'),de('yes'))#" value="#remoteID#">
							)
						</cfquery>
					</cfif>
				</cfloop>
		
	</cffunction>
	
	<cffunction name="getToWorkCopy" returntype="void">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="mode" type="string" default="publish" required="true">
		<cfargument name="keyFactory" type="any" required="true">
			
		<cfset var keys=arguments.keyFactory/>
		<cfset var rsContent=""/>
		<cfset var rsContentObjects=""/>
		<cfset var rsContentTags=""/>
		<cfset var rsSystemObjects=""/>
		<cfset var rstpermissions=""/>
		<cfset var rsSettings=""/>
		<cfset var rstadcampaigns=""/>
		<cfset var rstadcreatives=""/>
		<cfset var rstadipwhitelist=""/>
		<cfset var rstadzones=""/>
		<cfset var rstadplacements=""/>
		<cfset var rstadplacementdetails=""/>
		<cfset var rstcontentcategoryassign=""/>
		<cfset var rstcontentfeeds=""/>
		<cfset var rstcontentfeeditems=""/>
		<cfset var rstcontentfeedadvancedparams=""/>
		<cfset var rstcontentrelated=""/>
		<cfset var rsMailinglist=""/>
		<cfset var rsFiles=""/>
		<cfset var rstcontentcategories=""/>
		<cfset var rstcontentcomments=""/>
		<cfset var rstcontentratings=""/>
		<cfset var rstusersinterests=""/>
		<cfset var rstclassextend=""/>
		<cfset var rstclassextendsets=""/>
		<cfset var rstclassextendattributes=""/>
		<cfset var rstclassextenddata=""/>
		<cfset var getNewID=""/>
		<cfset var rstpluginscripts=""/>
		<cfset var rstplugindisplayobjects=""/>
		<cfset var rstpluginsettings=""/>		
			
				<cfquery datasource="#arguments.toDSN#">
					delete from tclassextend
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and type not in ('1','2','User','Group')
				</cfquery>
				
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextend">
					select * from tclassextend where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and type not in ('1','2','User','Group')
				</cfquery>
				
				<cfloop query="rstclassextend">
					<cfquery datasource="#arguments.toDSN#">
						insert into tclassextend (subTypeID,siteID, baseTable, baseKeyField, dataTable, type, subType,
						isActive, notes, lastUpdate, dateCreated, lastUpdateBy)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(subTypeID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(baseTable neq '',de('no'),de('yes'))#" value="#baseTable#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(baseKeyField neq '',de('no'),de('yes'))#" value="#baseKeyField#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(baseTable neq '',de('no'),de('yes'))#" value="#baseTable#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(subType neq '',de('no'),de('yes'))#" value="#subType#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(isActive neq '',de('no'),de('yes'))#" value="#isActive#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(notes neq '',de('no'),de('yes'))#" value="#notes#">,
						#createODBCDateTime(now())#,
						#createODBCDateTime(now())#,
						'System'
						)
					</cfquery>
				</cfloop>
				
				<cfquery datasource="#arguments.toDSN#">
					delete from tclassextendsets
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and subTypeID not in (
								select subTypeID 
								from tclassextend 
								where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
								and type not in ('1','2','User','Group')
								)
				</cfquery>
				
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextendsets">
					select * from tclassextendsets 
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and subTypeID not in (
								select subTypeID 
								from tclassextend 
								where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/> 
								and type not in ('1','2','User','Group')
								)
				</cfquery>
				
				<cfloop query="rstclassextendsets">
					<cfquery datasource="#arguments.toDSN#">
						insert into tclassextendsets (extendsetID, subTypeID, categoryID, siteID, name, orderno, isActive, container)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(extendSetID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(subTypeID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(categoryID neq '',de('no'),de('yes'))#" value="#categoryID#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
						<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(orderno neq '',de('no'),de('yes'))#" value="#orderno#">,
						<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isActive neq '',de('no'),de('yes'))#" value="#isActive#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(container neq '',de('no'),de('yes'))#" value="#container#">
						)
					</cfquery>
				</cfloop>
				
				<cfquery datasource="#arguments.toDSN#">
					delete from tclassextendattributes
					where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/>
					and extendSetID not in (
							select extendSetID from tclassextendsets
							inner join tclassextend on (tclassextendsets.subTypeID=tclassextend.subTypeID)
							where tclassextend.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/> 
							and tclassextend.type not in ('1','2','User','Group')		
							)
				</cfquery>
				
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextendattributes">
					select * from tclassextendattributes where siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
				</cfquery>
				
				<cfloop query="rstclassextendattributes">
					<cfquery datasource="#arguments.toDSN#">
						insert into tclassextendattributes (extendSetID, siteID, name, label, hint, 
							type, orderno, isActive, required, validation, regex, message, defaultValue, optionList, optionLabelList)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(extendSetID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.toSiteID#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(label neq '',de('no'),de('yes'))#" value="#label#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(hint neq '',de('no'),de('yes'))#" value="#hint#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(type neq '',de('no'),de('yes'))#" value="#type#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(orderno neq '',de('no'),de('yes'))#" value="#orderno#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="#iif(isActive neq '',de('no'),de('yes'))#" value="#isActive#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(required neq '',de('no'),de('yes'))#" value="#required#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(validation neq '',de('no'),de('yes'))#" value="#validation#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(regex neq '',de('no'),de('yes'))#" value="#regex#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(message neq '',de('no'),de('yes'))#" value="#message#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(defaultValue neq '',de('no'),de('yes'))#" value="#defaultValue#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(optionList neq '',de('no'),de('yes'))#" value="#optionList#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(optionLabelList neq '',de('no'),de('yes'))#" value="#optionLabelList#">
						)
					</cfquery>
					
					<cfquery name="getNewID" datasource="#arguments.toDSN#">
					select max(attributeID) as newID from tclassextendattributes
					</cfquery>
					
					<cfset keys.get(attributeID, getNewID.newID)>
				</cfloop>
				
				<cfquery datasource="#arguments.fromDSN#" name="rstclassextenddata">
					select tclassextenddata.baseID, tclassextenddata.attributeID, tclassextenddata.attributeValue, 
					tclassextenddata.siteID, tclassextenddata.stringvalue, tclassextenddata.numericvalue, tclassextenddata.datetimevalue, tclassextenddata.remoteID from tclassextenddata 
					inner join tcontent on (tclassextenddata.baseid=tcontent.contenthistid)
					where tclassextenddata.siteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/>
					and tcontent.active = 1
				</cfquery>
				
				<cfloop query="rstclassextenddata">
					<cftry>
						<cfquery datasource="#arguments.toDSN#">
							insert into tclassextenddata (baseID,attributeID,attributeValue,siteID,stringvalue,numericvalue,datetimevalue,remoteID)
							values
							(
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(baseID)#">,
							<cfqueryparam cfsqltype="cf_sql_INTEGER" value="#keys.get(attributeID)#">,
							<cfqueryparam cfsqltype="cf_sql_LONGVARCHAR" null="#iif(attributeValue neq '',de('no'),de('yes'))#" value="#attributeValue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.tositeID#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(stringvalue neq '',de('no'),de('yes'))#" value="#stringvalue#">,
							<cfqueryparam cfsqltype="cf_sql_NUMERIC" null="#iif(isNumeric(numericvalue),de('no'),de('yes'))#" value="#numericvalue#">,
							<cfqueryparam cfsqltype="cf_sql_TIMESTAMP" null="#iif(isDate(datetimevalue),de('no'),de('yes'))#" value="#datetimevalue#">,
							<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(remoteID neq '',de('no'),de('yes'))#" value="#remoteID#">
							)
						</cfquery>
						<cfcatch>
							<cfdump var="#baseID#">
							<cfdump var="#attributeID#">
							<cfdump var="#attributeValue#">
							<cfdump var="#cfcatch#">
							<cfabort>
						</cfcatch>
					</cftry>
				</cfloop>
		
	</cffunction>
	
	<cffunction name="getToWorkCopySameDSN" returntype="void">
		<cfargument name="fromSiteID" type="string" default="" required="true">
		<cfargument name="toSiteID" type="string" default="" required="true">
		<cfargument name="fromDSN" type="string" default="" required="true">
		<cfargument name="toDSN" type="string" default="" required="true">
		<cfargument name="mode" type="string" default="publish" required="true">
		<cfargument name="keyFactory" type="any" required="true">
			
		<cfset var keys=arguments.keyFactory/>
		<cfset var rsContent=""/>
		<cfset var rsContentObjects=""/>
		<cfset var rsContentTags=""/>
		<cfset var rsSystemObjects=""/>
		<cfset var rstpermissions=""/>
		<cfset var rsSettings=""/>
		<cfset var rstadcampaigns=""/>
		<cfset var rstadcreatives=""/>
		<cfset var rstadipwhitelist=""/>
		<cfset var rstadzones=""/>
		<cfset var rstadplacements=""/>
		<cfset var rstadplacementdetails=""/>
		<cfset var rstcontentcategoryassign=""/>
		<cfset var rstcontentfeeds=""/>
		<cfset var rstcontentfeeditems=""/>
		<cfset var rstcontentfeedadvancedparams=""/>
		<cfset var rstcontentrelated=""/>
		<cfset var rsMailinglist=""/>
		<cfset var rsFiles=""/>
		<cfset var rstcontentcategories=""/>
		<cfset var rstcontentcomments=""/>
		<cfset var rstcontentratings=""/>
		<cfset var rstusersinterests=""/>
		<cfset var rstclassextend=""/>
		<cfset var rstclassextendsets=""/>
		<cfset var rstclassextendattributes=""/>
		<cfset var rstclassextenddata=""/>
		<cfset var getNewID=""/>
		<cfset var rstpluginscripts=""/>
		<cfset var rstplugindisplayobjects=""/>
		<cfset var rstpluginsettings=""/>		
		
		
				
				<cfquery datasource="#arguments.toDSN#">
					delete from tpluginscripts 
					where moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/> and type='Plugin')
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#" name="rstpluginscripts">
					select * from tpluginscripts 
					where moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/> and type='Plugin')
				</cfquery>
				
				<cfloop query="rstpluginscripts">
					<cfquery datasource="#arguments.toDSN#">
						insert into tpluginscripts (scriptID,moduleID,scriptfile,runat,docache)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(scriptID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(moduleID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(scriptfile neq '',de('no'),de('yes'))#" value="#scriptfile#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(runat neq '',de('no'),de('yes'))#" value="#runat#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(docache),de(docache),de(0))#">
						
						)
					</cfquery>
				</cfloop>
				
				<cfquery datasource="#arguments.toDSN#">
					delete from tplugindisplayobjects 
					where moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/> and type='Plugin')
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#" name="rstplugindisplayobjects">
					select * from tplugindisplayobjects 
					where moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/> and type='Plugin')
				</cfquery>
				<cfloop query="rstplugindisplayobjects">
					<cfquery datasource="#arguments.toDSN#">
						insert into tplugindisplayobjects (objectID,moduleID,name,location,displayObjectFile,displayMethod,docache)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(objectID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(moduleID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(location neq '',de('no'),de('yes'))#" value="#location#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(displayObjectFile neq '',de('no'),de('yes'))#" value="#displayObjectFile#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(displayMethod neq '',de('no'),de('yes'))#" value="#displayMethod#">,
						<cfqueryparam cfsqltype="cf_sql_INTEGER" null="no" value="#iif(isNumeric(docache),de(docache),de(0))#">
						
						)
					</cfquery>
				</cfloop>
				
				<cfquery datasource="#arguments.toDSN#">
					delete from tpluginsettings 
					where moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tositeid#"/> and type='Plugin')
				</cfquery>
				<cfquery datasource="#arguments.fromDSN#" name="rstpluginsettings">
					select * from tpluginsettings 
					where moduleID in ( select moduleID from tcontent where siteid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromsiteid#"/> and type='Plugin')
				</cfquery>
				<cfloop query="rstpluginsettings">
					<cfquery datasource="#arguments.toDSN#">
						insert into tpluginsettings (moduleID,name,settingValue)
						values
						(
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#keys.get(moduleID)#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(name neq '',de('no'),de('yes'))#" value="#name#">,
						<cfqueryparam cfsqltype="cf_sql_VARCHAR" null="#iif(settingValue neq '',de('no'),de('yes'))#" value="#settingValue#">
						
						)
					</cfquery>
				</cfloop>
		
		
	</cffunction>
	
	<cffunction name="publish" returntype="void">
		<cfargument name="siteid" required="yes" default="">
		<cfargument name="pushMode" required="yes" default="">

		<cfset var i=""/>
		<cfset var j=""/>
		<cfset var k=""/>
		<cfset var p=""/>
		<cfset var fileDelim=application.configBean.getFileDelim() />
		<cfset var rsPlugins=application.pluginManager.getSitePlugins(arguments.siteid)>
		<cfset var pluginEvent = createObject("component","mura.event").init(arguments) />
		<cfset var keys=createObject("component","mura.publisherKeys").init('publish',application.utility)>
		<cfset var fileWriter=application.serviceFactory.getBean("fileWriter")>
		<cfset var errors=arrayNew(1)>
		<cfset var itemErrors=arrayNew(1)>
		<cfset var publisherPushMode="Full">
		<cfset var lastDeployment=application.settingsManager.getSite(arguments.siteID).getLastDeployment()>
		<cfset var rsDeleted=queryNew("objectID")>
		
		<cfif len(arguments.pushMode)>
			<cfset publisherPushMode=arguments.pushMode>
		<cfelseif isDate(lastDeployment) and application.configBean.getPushlisherPushMode() eq "UpdatesOnly">
			<cfset publisherPushMode="UpdatesOnly">
		</cfif>
		
		<cfif publisherPushMode eq "UpdatesOnly" and isDate(lastDeployment)>
			<cfset rsDeleted=getBean("trashManager").getQuery(siteID=arguments.fromSiteID,sinceDate=lastDeployment)>
		<cfelse>
			<cfset rsDeleted=queryNew("objectID")>
		</cfif>
		
		<cfset application.pluginManager.announceEvent("onSiteDeploy",pluginEvent)>
		<cfset application.pluginManager.announceEvent("onBeforeSiteDeploy",pluginEvent)>
		
		<cfloop list="#application.configBean.getProductionDatasource()#" index="i">
			<cfset getToWork(arguments.siteid, arguments.siteid, '#application.configBean.getDatasource()#', '#i#','publish',keys,publisherPushMode,lastDeployment,rsDeleted)>
			<cfif len(application.configBean.getAssetPath())>
				<cfset update("#application.configBean.getAssetPath()#","#application.configBean.getProductionAssetPath()#",i)>
			</cfif>
		</cfloop>
		
		<cfif publisherPushMode eq "Full">
			<cfloop list="#application.configBean.getProductionWebroot()#" index="j">
				<cfset itemErrors=application.utility.copyDir("#application.configBean.getWebRoot()##fileDelim##arguments.siteid##fileDelim#", "#j##fileDelim##arguments.siteid##fileDelim#") />
				<cfset errors=application.utility.joinArrays(errors,itemErrors)>
			</cfloop>
		</cfif>
		
		<cfloop list="#application.configBean.getProductionWebroot()#" index="p">
			<cfloop query="rsPlugins">
				<cfset itemErrors=application.utility.copyDir("#application.configBean.getWebRoot()##fileDelim#plugins#fileDelim##rsPlugins.directory##fileDelim#", "#p##fileDelim#plugins#fileDelim##rsPlugins.directory##fileDelim#","",lastDeployment) />
				<cfset errors=application.utility.joinArrays(errors,itemErrors)>
			</cfloop>
			<!--- delete mappings file so that it will be recreated but prod instance --->
			<cfif fileExists("#p##fileDelim#plugins#fileDelim#mappings.cfm")>
				<cffile action="delete" file="#p##fileDelim#plugins#fileDelim#mappings.cfm">
			</cfif>
		</cfloop>
			
		<cfif publisherPushMode neq "UpdatesOnly">
			<cfset lastDeployment="">
		</cfif>
		
		<cfloop list="#application.configBean.getProductionFiledir()#" index="k">
				<cfset itemErrors=application.utility.copyDir("#application.configBean.getFiledir()##fileDelim##arguments.siteid##fileDelim#", "#k##fileDelim##arguments.siteid##fileDelim#","",lastDeployment) />
				<cfset errors=application.utility.joinArrays(errors,itemErrors)>
		</cfloop>
		
		<cfloop list="#application.configBean.getProductionAssetdir()#" index="k">
			<cfif not listFindNoCase(application.configBean.getProductionFiledir(),k)>
				<cfset itemErrors=application.utility.copyDir("#application.configBean.getAssetdir()##fileDelim##arguments.siteid##fileDelim#", "#k##fileDelim##arguments.siteid##fileDelim#","",lastDeployment) />
				<cfset errors=application.utility.joinArrays(errors,itemErrors)>
			</cfif>
		</cfloop>
		
		<!---
		<cfif len(application.configBean.getAssetPath())>
			<cfset update("#application.configBean.getAssetPath()#","#application.configBean.getProductionAssetPath()#")>
		</cfif>
		--->
		
		<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			update tsettings set lastDeployment = #now()#
			where siteID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.siteID#">
		</cfquery>
		
		<cfloop list="#application.configBean.getProductionDatasource()#" index="i">
			<cfquery datasource="#i#">
				update tsettings set lastDeployment = #now()#
				where siteID=<cfqueryparam cfsqltype="cf_sql_VARCHAR" value="#arguments.siteID#">
			</cfquery>
			<cfquery datasource="#i#">
				update tglobals set appreload = #now()#
			</cfquery>
		</cfloop>
		
		<cfset pluginEvent.setValue("errors",errors)>
		<cfset application.pluginManager.announceEvent("onAfterSiteDeploy",pluginEvent)>
	</cffunction>
	
	<cffunction name="copy" returntype="void" output="no">
		<cfargument name="fromsiteid" required="yes" default="">
		<cfargument name="tositeid" required="yes" default="">
		<cfargument name="fromDSN" required="yes" default="#application.configBean.getDatasource()#">
		<cfargument name="toDSN" required="yes" default="#application.configBean.getDatasource()#">
		<cfargument name="fromWebRoot" required="yes" default="#application.configBean.getWebRoot()#">
		<cfargument name="toWebRoot" required="yes" default="#application.configBean.getWebRoot()#">
		<cfargument name="fromFileDir" required="yes" default="#application.configBean.getFileDir()#">
		<cfargument name="toFileDir" required="yes" default="#application.configBean.getFileDir()#">
		<cfargument name="fromAssetDir" required="yes" default="#application.configBean.getAssetDir()#">
		<cfargument name="toAssetDir" required="yes" default="#application.configBean.getAssetDir()#">
		<cfargument name="fromAssetPath" required="yes" default="#application.configBean.getAssetPath()#">
		<cfargument name="toAssetPath" required="yes" default="#application.configBean.getAssetPath()#">
		
		<cfset var i=""/>
		<cfset var j=""/>
		<cfset var k=""/>
		<cfset var p=""/>
		<cfset var pluginEvent = createObject("component","mura.event") />
		<cfset var fileDelim="/"/>
		<cfset var rsplugins=""/>
		<cfset var keys=""/>
		
		<cfloop collection="#arguments#" item="i">
			<cfset variables[i] = arguments[i]>
		</cfloop>
		
		
		<cfset variables.siteID=arguments.fromSiteID>
		<cfset pluginEvent.init(variables)>
		<cfset application.pluginManager.announceEvent("onSiteCopy",pluginEvent)>
		
		<cfset fileDelim=application.configBean.getFileDelim() />
		<cfset rsPlugins=application.pluginManager.getSitePlugins(arguments.fromsiteid)>
		<cfset keys=createObject("component","mura.publisherKeys").init('copy',application.utility)>
		
			
		<!---<cfthread action="run" name="thread0">--->
			<cfset getToWork(fromsiteid, tositeid, fromDSN, toDSN, 'copy', keys, 'full')>
		<!---</cfthread>--->
				
		<!---<cfthread action="run" name="thread1">--->
			<cfset application.utility.copyDir("#fromWebRoot##fileDelim##fromsiteid##fileDelim#", "#toWebRoot##fileDelim##tositeid##fileDelim#","cache#fileDelim#file") />
		<!---</cfthread>--->
		
		<cfif arguments.fromWebRoot neq arguments.toWebRoot>
			<cfloop query="rsPlugins">
				<!---<cfthread action="run" name="thread2#rsPlugins.currentRow#">--->
					<cfset application.utility.copyDir("#fromWebRoot##fileDelim#plugins#fileDelim##rsPlugins.directory##fileDelim#", "#toWebRoot##fileDelim#plugins#fileDelim##rsPlugins.directory##fileDelim#") />
				<!---</cfthread>--->
			</cfloop>
		</cfif>
		
		<!---<cfif fromWebRoot neq fromFileDir>--->
			<!---<cfthread action="run" name="thread3">--->
				<cfset copySiteFiles("#fromFileDir##fileDelim##fromsiteid##fileDelim#cache#fileDelim#file#fileDelim#", "#toFileDir##fileDelim##tositeid##fileDelim#cache#fileDelim#file#fileDelim#",keys) />
			<!---</cfthread>--->
		<!---</cfif>--->
		
		<cfif arguments.toWebRoot neq arguments.toAssetDir>
			<!---<cfthread action="run" name="thread4">--->
				<cfset application.utility.copyDir("#fromAssetDir##fileDelim##fromsiteid##fileDelim#assets#fileDelim#", "#toAssetDir##fileDelim##tositeid##fileDelim#assets#fileDelim#") />
			<!---</cfthread>--->
		</cfif>
		<!---
		<cfthread action="join" name="thread0" />
		--->		
		<!---<cfthread action="run" name="thread5">--->
			<cfif fromAssetPath neq toAssetPath>
				<cfset application.contentUtility.findAndReplace("#fromAssetPath#", "#toAssetPath#", "#toSiteID#")>
			</cfif>
		<!---</cfthread>--->
		
		<!---<cfthread action="run" name="thread6">--->
			<cfif fromSiteID neq toSiteID>
				<cfset application.contentUtility.findAndReplace("/#fromsiteID#", "/#toSiteID#", "#toSiteID#")>
			</cfif>
		<!---</cfthread>--->
		
		<cfset application.serviceFactory.getBean("contentUtility").updateGlobalMaterializedPath(siteid=arguments.toSiteID,datasource=arguments.toDSN) />
		<cfset application.serviceFactory.getBean("categoryUtility").updateGlobalMaterializedPath(siteid=arguments.toSiteID,datasource=arguments.toDSN) />
		
	</cffunction>
	
	<cffunction name="start" returntype="boolean">
		<cfargument name="siteid" required="yes" default="">
		<cfset var rsSites=""/>
		<cfif siteid neq "">
			<!--- publish just one --->
			<cfset publish(arguments.siteid)>
		<cfelse>
			<!--- publish all sites --->
			<cfquery name="rsSites"datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
				select siteid, deploy from tsettings
			</cfquery>
			<cfloop query="rsSites">
				<cfif deploy>
					<cfset publish(rsSites.siteid)>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn true />
	</cffunction>

	<cffunction name="copySiteFiles">
		<cfargument name="baseDir" default="" required="true" />
		<cfargument name="destDir" default="" required="true" />
		<cfargument name="keyFactory" required="true" />
		<cfargument name="sinceDate" default="" />
		<cfset var rs = "" />
		<cfset var keys=arguments.keyFactory>
		<cfset var newFile="">
		<cfset var newDir="">
		<cfset var fileDelim=application.configBean.getFileDelim()>
		<cfset var fileWriter=application.serviceFactory.getBean("fileWriter")>
		<cfdirectory directory="#arguments.baseDir#" name="rs" action="list" recurse="true" />
		<!--- filter out Subversion hidden folders --->
		<cfquery name="rs" dbtype="query">
		SELECT * FROM rs
		WHERE directory NOT LIKE '%#application.configBean.getFileDelim()#.svn%'
		AND name <> '.svn'
		
		<cfif isDate(arguments.sinceDate)>
		and dateLastModified >= #createODBCDateTime(arguments.sinceDate)#
		</cfif>
		</cfquery>
		
		<cfif not isDate(arguments.sinceDate) and directoryExists(arguments.destDir)>
			<cfset fileWriter.deleteDir(directory="#arguments.destDir#")>
		</cfif>
		
		<cfif not directoryExists(arguments.destDir)>
			<cfset fileWriter.createDir(directory="#arguments.destDir#")>
		</cfif>
		
		<cfloop query="rs">
			<cfif rs.type eq "dir">
				<cftry>
					<cfset newDir="#replace('#rs.directory##fileDelim#',arguments.baseDir,arguments.destDir)##rs.name##fileDelim#">
					<cfif not directoryExists(newDir)>
						<cfset fileWriter.createDir(directory=newDir)>
					</cfif>
					<cfcatch></cfcatch>
				</cftry>
			<cfelse>
				<!--- <cftry> --->

					<cfset fileWriter.copyFile(source="#rs.directory##fileDelim##rs.name#", destination=replace('#rs.directory##fileDelim#',arguments.baseDir,arguments.destDir))>

					<cfset newFile=listFirst(rs.name,".")>
					
					<cfif listLen(newFile,"_") gt 1>
						<cfset newFile=keys.get(listFirst(newFile,"_")) & "_" & listLast(newFile,"_") & "." & listLast(rs.name,".")>
					<cfelse>
						<cfset newFile=keys.get(newFile) & "." & listLast(rs.name,".")>	
					</cfif>
					
					<cfset fileWriter.renameFile(source="#replace('#rs.directory##fileDelim#',arguments.baseDir,arguments.destDir)##rs.name#", destination="#replace('#rs.directory##fileDelim#',arguments.baseDir,arguments.destDir)##newFile#")>
				<!--- 	<cfcatch></cfcatch>
				</cftry> --->
			</cfif>
		</cfloop>
	</cffunction>
	
</cfcomponent>