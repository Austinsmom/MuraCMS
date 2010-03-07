<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.userBean="">

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true" />
<cfset var prop="">
<cfset var prefix=left(arguments.MissingMethodName,3)>
<cfset var theValue="">
<cfset var bean="">

<cfif len(arguments.MissingMethodName)>

	<!--- forward normal getters to the default getValue method --->
	<cfif prefix eq "get" and len(arguments.MissingMethodName)gt 3>
		<cfset prop=right(arguments.MissingMethodName,len(arguments.MissingMethodName)-3)>
		<cfreturn getValue(prop)>
	<!---
	<cfelseif listfindNoCase("get,set",arguments.MissingMethodName) and not structIsEmpty(MissingMethodArguments)>
		<cfif arguments.MissingMethodName eq "get">
			<cfreturn getValue(argumentCollection=MissingMethodArguments)>
		<cfelse>
			<cfreturn setValue(argumentCollection=MissingMethodArguments)>
		</cfif>
	--->
	</cfif>
	
	<!--- otherwise get the bean and if the method exsists forward request --->
	<cfset bean=getUserBean()>
	
	<cfif structKeyExists(bean,arguments.MissingMethodName)>
		<cfif not structIsEmpty(MissingMethodArguments)>
			<cfinvoke component="#bean#" method="#MissingMethodName#" argumentcollection="#MissingMethodArguments#" returnvariable="theValue">
		<cfelse>
			<cfinvoke component="#bean#" method="#MissingMethodName#" returnvariable="theValue">
		</cfif>
		
		<cfif isDefined("theValue")>
			<cfreturn theValue>
		<cfelse>
			<cfreturn "">
		</cfif>
		
	<cfelse>
		<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">
	</cfif>

<cfelse>
	<cfreturn "">
</cfif>

</cffunction>
		
<cffunction name="init" access="public" returntype="any" output="false">
	<cfreturn this>
</cffunction>

<cffunction name="getValue" access="public" returntype="any" output="false">
	<cfargument name="property">	
	<cfif structKeyExists(session.mura,arguments.property)>
		<cfreturn session.mura[arguments.property]>
	<cfelse>
		<cfreturn  getUserBean().getValue(arguments.property)>
	</cfif>
</cffunction>

<cffunction name="setValue" access="public" returntype="any" output="false">
	<cfargument name="property">
	<cfargument name="propertyValue">	
	
		<cfset session.mura[arguments.property]=arguments.propertyValue>
		<cfset getUserBean().setValue(arguments.property, arguments.propertyValue)>
		<cfreturn this>
</cffunction>

<cffunction name="getUserBean" access="public" returntype="any" output="false">
	<cfif isObject(variables.userBean) >
		<cfreturn variables.userBean>
	<cfelse>
		<cfset variables.userBean=application.userManager.read(session.mura.userID)>
	</cfif>
	<cfreturn variables.userBean>
</cffunction>

<cffunction name="getFullName" access="public" returntype="any" output="false">
	<cfreturn trim("#session.mura.fname# #session.mura.lname#")>
</cffunction>

<cffunction name="isInGroup" access="public" returntype="any" output="false">
	<cfargument name="group">
	<cfargument name="isPublic" hint="optional">
	<cfset var siteid=session.mura.siteID>
	<cfset var publicPool="">
	<cfset var privatePool="">
	
	<cfif structKeyExists(request,"siteid")>
		<cfset siteID=request.siteID>
	</cfif>
	
	<cfset publicPool=application.settingsManager.getSite(siteid).getPublicUserPoolID()>
	<cfset privatePool=application.settingsManager.getSite(siteid).getPrivateUserPoolID()>
	
	<cfif session.mura.isLoggedIn and len(siteID)>
		<cfif structKeyExists(arguments,"isPublic")>
			<cfif arguments.isPublic>
				<cfreturn application.permUtility.isUserInGroup(arguments.group,publicPool,1)>
			<cfelse>
				<cfreturn application.permUtility.isUserInGroup(arguments.group,privatePool,0)>
			</cfif>
		<cfelse>
			<cfreturn application.permUtility.isUserInGroup(arguments.group,publicPool,1) or application.permUtility.isUserInGroup(arguments.group,privatePool,0)>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="isPrivateUser" access="public" returntype="any" output="false">
	<cfset var siteid=session.mura.siteID>
	
	<cfif structKeyExists(request,"siteid")>
		<cfset siteID=request.siteID>
	</cfif>
	
	<cfreturn application.permUtility.isPrivateUser(siteid)>
</cffunction>

<cffunction name="isSuperUser" access="public" returntype="boolean" output="false">
	
	<cfreturn application.permUtility.isS2() />
	
</cffunction>

<cffunction name="isLoggedIn" access="public" returntype="boolean" output="false">
	
	<cfreturn session.mura.isLoggedIn />
	
</cffunction>

<cffunction name="logout" access="public" returntype="any" output="false">
	
	<cfset getBean('loginManager').logout()>
	<cfreturn this>
</cffunction>
</cfcomponent>