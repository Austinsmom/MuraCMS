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
	<cfargument name="configBean">
	
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.dsn=variables.configBean.getDatasource()/>
	
	<cfreturn this />
</cffunction>

<cffunction name="getSubTypeBean" returnType="any">
<cfset var subtype=createObject("component","mura.extend.extendSubType").init(variables.configBean) />
<cfreturn subtype />
</cffunction>

<cffunction name="getSubTypeByName" access="public" returntype="any">
<cfargument name="type">
<cfargument name="subtype">
<cfargument name="siteid">

	<cfset var _subtype=getSubTypeBean() />
	<cfset _subtype.setSiteID(arguments.siteID)/>
	<cfset _subtype.setType(arguments.type)/>
	<cfset _subtype.setSubType(arguments.SubType)/>
	<cfset _subtype.load() />
	<cfreturn _subtype />
</cffunction>

<cffunction name="getSubTypeByID" access="public" returntype="any">
<cfargument name="subTypeID">

	<cfset var subtype=getSubTypeBean() />
	<cfset subtype.setSubTypeID(arguments.SubTypeID)/>
	<cfset subtype.load() />
	
	<cfreturn subtype />
</cffunction>

<cffunction name="deleteSubType" access="public" returntype="array">
<cfargument name="subTypeID">
	<cfset var subtype=getSubTypeBean() />
	<cfset subtype.setSubTypeID(arguments.subtypeID)/> 
	<cfset subType.delete() />		
</cffunction>

<cffunction name="getExtendedData" access="public" returntype="any">
	<cfargument name="baseID">
	<cfargument name="dataTable" required="true" default="tclassextenddata"/>
	<cfargument name="lazyload" required="true" default="false"/>
	
	<cfset var extendData=createObject("component","mura.extend.extendData").init(variables.configBean,arguments.baseID,arguments.dataTable) />
	<cfif not arguments.lazyLoad>
		<cfset extendData.loadData()>
	</cfif>
	<cfreturn extendData/>
</cffunction>

<cffunction name="saveExtendedData" access="public" returntype="void">
<cfargument name="baseID">
<cfargument name="data">
<cfargument name="dataTable" required="true" default="tclassextenddata"/>

<cfset var setLen=0/>
<cfset var key=""/>
<cfset var fileManager=application.serviceFactory.getBean("fileManager") />
<cfset var fileID = ""/>
<cfset var fileStruct = ""/>
<cfset var formField = ""/>
<cfset var deleteKey1 = ""/>
<cfset var deleteKey2 = ""/>
<cfset var rs = ""/>
<cfset var theFileStruct=""/>
<cfset var theValue=""/>
<cfset var s=0/>

<cfif isDefined("arguments.data.extendSetID")>
<cfset setLen=listLen(arguments.data.extendSetID)/>

<!--- process non-file attributes --->
<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select attributeID,name from tclassextendattributes where 
ExtendSetID in(<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
		and type != 'File'
</cfquery>

<cfloop query="rs">
	<cfset key="ext#rs.attributeID#"/>
	
	<cfif structKeyExists(arguments.data,key)
		or structKeyExists(arguments.data,rs.name)>
		
		<cfif structKeyExists(arguments.data,key) and len(arguments.data[key])>
			<cfset theValue=arguments.data[key]>
		<cfelseif structKeyExists(arguments.data,rs.name) and len(arguments.data[rs.name])>
			<cfset theValue=arguments.data[rs.name]>
		<cfelse>
			<cfset theValue="">
		</cfif>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			delete from #arguments.dataTable# 
			where baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">
			and attributeID = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">
		</cfquery>
			
		<cfquery  datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into #arguments.dataTable# (baseID,attributeID,siteID,attributeValue)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.attributeID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.data.siteID#">,
			<cfif len(theValue)>
				<cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#theValue#">
			<cfelse>
				null
			</cfif>
			)
		</cfquery>
		
	</cfif>
</cfloop>

<!--- process file attributes --->
<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select attributeID,name from tclassextendattributes where 
ExtendSetID in(<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
		and type = 'File'
</cfquery>


<cfloop query="rs">
	<cfset key="ext#rs.attributeID#"/>
	<cfset deletekey1="extDelete#rs.attributeID#"/>
	<cfset deletekey2="extDelete#rs.name#"/>
	
	<!--- if a new file has been submitted or a delete key exists, delete any existing file --->
	<cfif (structKeyExists(arguments.data,key) and len(arguments.data[key]))
		or (structKeyExists(arguments.data,rs.name) and len(arguments.data[rs.name]))
		or structKeyExists(arguments.data,deletekey1) 
		or structKeyExists(arguments.data,deletekey2)>
	
	
		<cfset fileID=getAttribute(arguments.baseID,rs.attributeID,arguments.dataTable)/>
		
		<cfif len(fileID)>
			
			<cfset fileManager.deleteIfNotUsed(fileID,arguments.baseID)/>
			
			<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			delete from #arguments.dataTable# 
			where baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">
			and attributeID = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">
		 	</cfquery>
		 	
		 	<cfset fileID=""/>
		</cfif>	

	</cfif>
		
	<!--- if a new file has been submitted , save it --->
	<cfif (structKeyExists(arguments.data,key) and len(arguments.data[key]))
		or (structKeyExists(arguments.data,rs.name) and len(arguments.data[rs.name]))>
		
		<cfif structKeyExists(arguments.data,key) and len(arguments.data[key])>
			<cfset formField=key />
		<cfelse>
			<cfset formField=rs.name />
		</cfif>
		
		<cffile action="upload" filefield="#formField#" nameconflict="makeunique" destination="#getTempDirectory()#">
		<cfset theFileStruct=fileManager.process(file,arguments.data.siteID) />
		<cfset fileID=fileManager.create(theFileStruct.fileObj,arguments.baseID,arguments.data.siteID,file.ClientFile,file.ContentType,file.ContentSubType,file.FileSize,'00000000000000000000000000000000004',file.ServerFileExt,theFileStruct.fileObjSmall,theFileStruct.fileObjMedium) />
			
		<cfquery  datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
			insert into #arguments.dataTable# (baseID,attributeID,siteID,attributeValue)
			values (
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.attributeID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.data.siteID#">,
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#fileID#">	
			)
		</cfquery>
					
	</cfif>

</cfloop>


</cfif>

</cffunction>

<cffunction name="preserveExtendedData" access="public" returntype="void">
<cfargument name="baseID">
<cfargument name="preserveID" required="true" default="">
<cfargument name="data">
<cfargument name="dataTable" required="true" default="tclassextenddata"/>
<cfset var setLen=0/>
<cfset var rs=""/>
<cfset var rsItem=""/>
<cfset var deleteKey1 = ""/>
<cfset var deleteKey2 = ""/>
<cfset var key = ""/>
<cfset var s=0/>

<!--- preserve data from extendsets that were'nt submitted --->
<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select #arguments.dataTable#.* from #arguments.dataTable#
inner join tclassextendattributes on ( #arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
 where 
baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.preserveID#">
<cfif isDefined("arguments.data.extendSetID")>
<cfset setLen=listLen(arguments.data.extendSetID)/>
and tclassextendattributes.extendSetID not in (<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
</cfif>		
</cfquery>

<cfloop query="rs">
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		insert into #arguments.dataTable# (baseID,attributeID,siteID,attributeValue)
		values (
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
		<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">,
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.siteID#">,
		<cfif len(rs.attributeValue)>
		<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.attributeValue#">	
		<cfelse>
		null
		</cfif>
		)
		</cfquery>
</cfloop>

<!--- preserve get non file attributes that were'nt submitted along with extendedset  --->
<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select #arguments.dataTable#.*, tclassextendattributes.name from #arguments.dataTable#
inner join tclassextendattributes on ( #arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
 where 
baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.preserveID#">
<cfif isDefined("arguments.data.extendSetID")>
<cfset setLen=listLen(arguments.data.extendSetID)/>
and tclassextendattributes.extendSetID in (<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
</cfif>		
and type!='File'
</cfquery>

<cfloop query="rs">
<cfset key="ext#rs.attributeID#"/>
<cfif not structKeyExists(arguments.data,key)
	and not structKeyExists(arguments.data,rs.name)>
		
		<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
						insert into #arguments.dataTable# (baseID,attributeID,siteID,attributeValue)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
						<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.siteID#">,
						<cfif len(rs.attributeValue)>
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.attributeValue#">	
						<cfelse>
						null
						</cfif>
						)
			</cfquery>
		
	</cfif>
</cfloop>	

<!--- preserve  Files from submitted extendset and make sure that is they were'nt newly submitted that the fileID is carried forward--->
<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
select #arguments.dataTable#.*, tclassextendattributes.name from #arguments.dataTable#
inner join tclassextendattributes on ( #arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
 where 
baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.preserveID#">
<cfif isDefined("arguments.data.extendSetID")>
<cfset setLen=listLen(arguments.data.extendSetID)/>
and tclassextendattributes.extendSetID in (<cfloop from="1" to="#setLen#" index="s">
		'#listgetat(arguments.data.extendSetID,s)#'<cfif s lt setlen>,</cfif>
		</cfloop>)
</cfif>		
and type='File'
</cfquery>

<cfloop query="rs">
		<cfset key="ext#rs.attributeID#"/>
		<cfset deletekey1="extDelete#rs.attributeID#"/>
		<cfset deletekey2="extDelete#rs.name#"/> 
		
		<cfif not((structKeyExists(arguments.data,key) and len(arguments.data[key]))
			or (structKeyExists(arguments.data,rs.name) and len(arguments.data[rs.name]))
			or structKeyExists(arguments.data,deletekey1) 
			or structKeyExists(arguments.data,deletekey2))
			and len(rs.attributeValue)>
		
		
						<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
						insert into #arguments.dataTable# (baseID,attributeID,siteID,attributeValue)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">,
						<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rs.attributeID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.siteID#">,
						<cfif len(rs.attributeValue)>
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#rs.attributeValue#">	
						<cfelse>
						null
						</cfif>
						)
						</cfquery>

		</cfif>
</cfloop>

</cffunction>

<cffunction name="getTypeAsString" returntype="string">
<cfargument name="type">

<cfif isNumeric(arguments.type)>
	<cfif arguments.type eq 1>
	<cfreturn "User Group">
	<cfelse>
	<cfreturn "User">
	</cfif>
<cfelse>
	<cfreturn arguments.type />
</cfif>

</cffunction>

<cffunction name="getSubTypes" returntype="query">
<cfargument name="siteid">
<cfset var rs = ""/>
<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tclassextend 
	where 
	siteid=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.siteid#">
	order by type,subtype
	</cfquery>

<cfreturn rs />
</cffunction>

<cffunction name="getSubTypesByType" returntype="query">
<cfargument name="type">
<cfargument name="siteid">
<cfset var rs = ""/>
<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tclassextend 
	where 
	siteid=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.siteid#">
	and	type=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.type#">
	order by type,subtype
	</cfquery>

<cfreturn rs />
</cffunction>

<cffunction name="saveAttributeSort" returntype="void">
<cfargument name="attributeID">
<cfset var rs = ""/>
<cfset var a=0/>
<cfloop from="1" to="#listlen(arguments.attributeID)#" index="a">
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tclassextendattributes
	set orderno=#a#
	where 
	attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#listGetAt(arguments.attributeID,a)#">
	</cfquery>
</cfloop>

</cffunction>

<cffunction name="saveExtendSetSort" returntype="void">
<cfargument name="extendSetID">
<cfset var rs = ""/>
<cfset var s=0/>
<cfloop from="1" to="#listlen(arguments.extendSetID)#" index="s">
	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	update tclassextendsets
	set orderno=#s#
	where 
	extendSetID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#listGetAt(arguments.extendSetID,s)#">
	</cfquery>
</cfloop>

</cffunction>

<cffunction name="getAttribute" returnType="string" output="false">
<cfargument name="baseID" required="true" default=""/>
<cfargument name="key" required="true" default=""/>
<cfargument name="dataTable" required="true" default="tclassextenddata"/>
<cfset var rs =""/>

	<cfquery name="rs" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select #arguments.dataTable#.attributeValue,tclassextendattributes.defaultValue,#arguments.dataTable#.attributeID from tclassextendattributes
	left join #arguments.dataTable# ON (tclassextendattributes.attributeID=#arguments.dataTable#.attributeID)
	where 
	#arguments.dataTable#.baseID=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.baseID#">
	and (
		<cfif isNumeric(arguments.key)>
		tclassextendattributes.attributeID=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#arguments.key#">
		or</cfif>
		 tclassextendattributes.name=<cfqueryparam cfsqltype="cf_sql_varchar"  value="#arguments.key#">)
	</cfquery>
	
	<cfif len(rs.attributeID)>
		<cfreturn rs.attributeValue />
	<cfelse>
		<cfreturn rs.defaultValue />
	</cfif>
</cffunction>

<cffunction name="deleteExtendedData" output="false" returntype="void">
<cfargument name="baseid">
<cfargument name="dataTable" required="true" default="tclassextenddata">
<cfset var rsFiles="">
<cfset var fileManager=application.serviceFactory.getBean("fileManager") />

	<cfquery name="rsFiles" datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select attributeValue from #arguments.dataTable#
		inner join tclassextendattributes on (#arguments.dataTable#.attributeID=tclassextendattributes.attributeID)
		where 
		tclassextendattributes.type='File'
		and #arguments.dataTable#.baseid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseid#"/>
		and #arguments.dataTable#.attributeValue is not null
	</cfquery>
		
	<cfloop query="rsFiles">
		<cfset fileManager.deleteIfNotUsed(rsFiles.attributeValue,arguments.baseID)/>
	</cfloop>

	<cfquery datasource="#variables.dsn#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		delete from #arguments.dataTable# where 
	    baseid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.baseid#"/>
	</cfquery>		
		
</cffunction>

</cfcomponent>