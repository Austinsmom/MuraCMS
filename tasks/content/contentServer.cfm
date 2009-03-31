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


<cfif isDefined('url.path') and url.path neq application.configBean.getContext() & application.configBean.getStub() & "/">
<cfsetting enablecfoutputonly="yes">


<cfset last=listLast(url.path,"/") />

<cfif not structKeyExists(request,"preformated")>
<cfif last neq application.configBean.getIndexFile() and right(url.path,1) neq "/">
	<cfset application.contentRenderer.redirect("#url.path#/")>
</cfif>
</cfif>

<cfif isValid("UUID",last)>
	<cfquery name="rsRedirect" datasource="#application.configBean.getDatasource()#"  username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	select * from tredirects where redirectID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#last#">
	</cfquery>
	
	<cfif rsRedirect.url neq ''>
		<cflocation url="#rsRedirect.url#" addtoken="false">
	</cfif>
</cfif>

<cfset theStart = find(application.configBean.getStub(),url.path)>
<cfif theStart>
	<cfset url.path=mid(url.path,theStart,len(url.path)) />
</cfif>

<cfset trimLen=len(application.configBean.getStub())+1 />
<cfset tempfilename=right(url.path,len(url.path)-trimLen) />
<cfset request.siteid=listFirst(tempfilename,"/") />
<cfset request.currentFilename="" />

<cftry>
	<cfset application.settingsManager.getSite(request.siteid) />
	<cfcatch>
		<cflocation url="/" addtoken="false">
	</cfcatch>
</cftry>

<cfif listLen(tempfilename,'/') gt 1>
	<cfset theLen=listLen(tempfilename,'/')/>
	<cfloop from="2" to="#theLen#" index="n">
	<cfset item=listgetat(tempfilename,n,"/")/>
	<cfif not find(".",item)>
		<cfset request.currentFilename=listappend(request.currentFilename,item,"/") />
	</cfif>
	</cfloop>
</cfif>

<cfif right(request.currentFilename,1) eq "/">
	<cfset request.currentFilename=left(request.currentFilename,len(request.currentFilename)-1)/>
</cfif>

<cfset request.servletEvent = createObject("component","mura.servletEvent").init() />
<cfset request.servlet = createObject("component","#application.configBean.getWebRootMap()#.#request.siteid#.includes.servlet").init(request.servletEvent) />
<cfset application.pluginManager.executeScripts('onSiteRequestStart',request.servletEvent.getValue('siteid'),request.servletEvent)/>
<cfset request.servlet.onRequestStart() />
<cfset layout=request.servlet.doRequest()>
<cfset request.servlet.onRequestEnd() />
<cfset application.pluginManager.executeScripts('onSiteRequestEnd',request.servletEvent.getValue('siteid'),request.servletEvent)/>

<cfoutput>#layout#</cfoutput>

<cfsetting enablecfoutputonly="no">  
<cfelse>
	<cfinclude template="redirect.cfm">
</cfif> 
