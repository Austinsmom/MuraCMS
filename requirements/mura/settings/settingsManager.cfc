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

<cffunction name="init" access="public" returntype="any" output="false">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="utility" type="any" required="yes"/>
<cfargument name="settingsGateway" type="any" required="yes"/>
<cfargument name="settingsDAO" type="any" required="yes"/>

		<cfset variables.configBean=arguments.configBean />
		<cfset variables.utility=arguments.utility />
		<cfset variables.Gateway=arguments.settingsGateway />
		<cfset variables.DAO=arguments.settingsDAO />
		
		<cfset setSites() />

<cfreturn this />
</cffunction>

<cffunction name="getList" access="public" output="false" returntype="query">

	<cfset var rs = variables.gateway.getList() />
	
	<cfreturn rs />
	
</cffunction>

<cffunction name="publishSite" access="public" output="false" returntype="void">
<cfargument name="siteID" required="yes" default="">

	<cfset application.serviceFactory.getBean("publisher").start(arguments.siteid) />
	<cfset variables.utility.broadcastAppreload() />
	
</cffunction>

<cffunction name="saveOrder" access="public" output="false" returntype="void">
<cfargument name="orderno" required="yes" default="">
<cfargument name="orderID" required="yes" default="">

<cfset var i=0/>
	
	<cfif arguments.orderID neq ''>
		<cfloop from="1" to="#listlen(arguments.orderid)#" index="i">
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tsettings set orderno= #listgetat(arguments.orderno,i)# where siteid ='#listgetat(arguments.orderid,i)#'
		</cfquery>
		</cfloop>
	</cfif>
	
	<cfobjectcache action="clear"/>
	
</cffunction>

<cffunction name="saveDeploy" access="public" output="false" returntype="void">
<cfargument name="deploy" required="yes" default="">
<cfargument name="orderID" required="yes" default="">
 <cfset var i=0/>	
	<cfif arguments.deploy neq '' and arguments.orderID neq ''>
		<cfloop from="1" to="#listlen(arguments.orderid)#" index="i">
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		update tsettings set deploy= #listgetat(arguments.deploy,i)# where siteid ='#listgetat(arguments.orderid,i)#'
		</cfquery>
		</cfloop>
	</cfif>
	
</cffunction>


<cffunction name="read" access="public" output="false" returntype="any">
<cfargument name="siteid" type="string" />

	<cfreturn variables.DAO.read(arguments.siteid) />
	
</cffunction>

<cffunction name="update" access="public" output="false" returntype="any">
	<cfargument name="data" type="struct" />
	
	<cfset var bean=variables.DAO.read(arguments.data.SiteID) />
	<cfset bean.set(arguments.data) />
	
	<cfif structIsEmpty(bean.getErrors())>
		<cfset variables.utility.logEvent("SiteID:#bean.getSiteID()# Site:#bean.getSite()# was updated","mura-settings","Information",true) />
		<cfset variables.DAO.update(bean) />
		<cfset setSites()/>
	</cfif>

	<cfreturn bean />

</cffunction>

<cffunction name="delete" access="public" output="false" returntype="void">
	<cfargument name="siteid" type="string" />
	
	<cfset var bean=read(arguments.siteid) />
	<cfset variables.utility.logEvent("SiteID:#arguments.siteid# Site:#bean.getSite()# was deleted","mura-settings","Information",true) />
	<cfset variables.DAO.delete(arguments.siteid) />
	<cfset setSites() />
	<cfset variables.utility.deleteDir("#variables.configBean.getWebRoot()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#") />
	<cfset variables.utility.deleteDir("#variables.configBean.getFileDir()##variables.configBean.getFileDelim()##arguments.siteid##variables.configBean.getFileDelim()#") />
</cffunction>

<cffunction name="create" access="public" output="false" returntype="any">
	<cfargument name="data" type="struct" />
	<cfset var rs=""/>
	<cfset var bean=application.serviceFactory.getBean("settingsBean") />
	<cfset bean.set(arguments.data) />
	
	<cfif structIsEmpty(bean.getErrors()) and  bean.getSiteID() neq ''>
		
		<cfquery name="rs" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select siteid from tsettings where siteid='#bean.getSiteID()#'
		</cfquery>
		
		<cfif rs.recordcount>
			<cfthrow message="The SiteID you entered is allready being used.">
			<cfabort>
		</cfif>
		
		<cfset variables.utility.logEvent("SiteID:#bean.getSiteID()# Site:#bean.getSite()# was created","mura-settings","Information",true) />
		<cfset variables.DAO.create(bean) />
		<cfset variables.utility.copyDir("#variables.configBean.getWebRoot()##variables.configBean.getFileDelim()#default#variables.configBean.getFileDelim()#", "#variables.configBean.getWebRoot()##variables.configBean.getFileDelim()##bean.getSiteID()##variables.configBean.getFileDelim()#") />
		<cfset variables.utility.createRequiredSiteDirectories(bean.getSiteID()) />
		<cfset setSites() />
	</cfif>

	<cfreturn bean />
</cffunction>

<cffunction name="setSites" access="public" output="false" returntype="void">
	<cfset var rs="" />
	<cfobjectcache action="clear">
	<cfset rs=getList() />
	<cfset variables.sites=structNew() />

	<cfloop query="rs">
		<cfset variables.sites['#rs.siteid#']=variables.DAO.read(rs.siteid) />
		<cfset variables.utility.createRequiredSiteDirectories(rs.siteid) />
 	</cfloop>
	
</cffunction>

<cffunction name="getSite" access="public" output="false" returntype="any">
	<cfargument name="siteid" type="string" />
	<cftry>
	<cfreturn variables.sites['#arguments.siteid#'] />
	<cfcatch>
			<cfset setSites() />
			<cfreturn variables.sites['#arguments.siteid#'] />	
	</cfcatch>
	</cftry>
</cffunction>

<cffunction name="getSites" access="public" output="false" returntype="any">
	<cfreturn variables.sites />
</cffunction>

<cffunction name="purgeAllCache" access="public" output="false" returntype="void">
	<cfset var rs=getList()>
	<cfset var clusterIPList=variables.configBean.getClusterIPList()>
	<cfset var ip="">
	
	<cfloop query="rs">
		<cfset getSite(rs.siteid).getCacheFactory().purgeAll()/>
	</cfloop>
	
	<cfif len(clusterIPList)>
		<cfloop list="#clusterIPList#" index="ip">
			<cfinvoke webservice="http://#ip##variables.configBean.getPort()##variables.configBean.getContext()#/mura.cfc?wsdl" method="purgeSiteCache">
			<cfinvokeargument name="siteID" value="">
			<cfinvokeargument name="appreloadkey" value="#variables.configBean.getAppreloadKey()#">
		 	</cfinvoke>
		</cfloop>
	</cfif>
</cffunction>

<cffunction name="getUserSites" access="public" output="false" returntype="query">
<cfargument name="siteArray" type="array" required="yes" default="#arrayNew(1)#">
<cfargument name="isS2" type="boolean" required="yes" default="false">
	<cfset var rs=""/>
	<cfset var counter=1/>
	<cfset var rsSites=getList()/>
	<cfset var s=0/>
	<cfquery name="rs" dbtype="query">
		select * from rsSites
		<cfif arrayLen(arguments.siteArray) and not arguments.isS2>
			where siteid in (
			<cfloop from="1" to="#arrayLen(arguments.siteArray)#" index="s">
			'#arguments.siteArray['#s#']#'
			<cfif counter lt arrayLen(arguments.siteArray)>,</cfif>
			<cfset counter=counter+1>
			</cfloop>)
		<cfelseif not arrayLen(arguments.siteArray) and not arguments.isS2>
		where 0=1
		</cfif>
		
	</cfquery>

	<cfreturn rs />
</cffunction>



</cfcomponent>