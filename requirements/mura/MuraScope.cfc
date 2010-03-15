<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance.contentRenderer="">
<cfset variables.instance.contentBean="">
<cfset variables.instance.event="">

<cffunction name="init" output="false">
	<cfargument name="data">
	<cfif isObject(arguments.data)>
		<cfset setEvent(arguments.data)>
	<cfelse>
		<cfset arguments.data.muraScope=this>
		<cfset setEvent(createObject("component","mura.event").init(arguments.data))>
	</cfif>
		
	<cfif isObject(event("contentBean"))>
		<cfset setContentBean(event("contentBean"))>
	</cfif>
	<cfif isObject(event("contentRenderer"))>
		<cfset setContentRenderer(event("contentRenderer"))>
	</cfif>
	
	<cfreturn this>
</cffunction>

<cffunction name="getContentRenderer" output="false" returntype="any">
	<cfif not isObject(variables.instance.contentRenderer)>
		<cfif structKeyExists(request,"contentRenderer")>
			<cfset setContentRenderer(request.contentRenderer)>
		<cfelseif len(event('siteid'))>
			<cfset setContentRenderer(createObject("component","#siteConfig().getAssetMap()#.contentRenderer").init(event))>
		<cfelseif structKeyExists(application,"contentRenderer")>
			<cfset setContentRenderer(application.contentRenderer)>
		</cfif>
	</cfif>
	<cfreturn variables.instance.contentRenderer>
</cffunction>

<cffunction name="setContentRenderer" output="false" returntype="any">
	<cfargument name="contentRenderer">
	<cfif isObject(arguments.contentRenderer)>
		<cfset variables.instance.contentRenderer=arguments.contentRenderer>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getContentBean" output="false" returntype="any">
	<cfif not isObject(variables.instance.contentBean) and structKeyExists(request,"contentbean")>
		<cfset setContentBean(request.contentBean)>
	</cfif>
	<cfreturn variables.instance.contentBean>
</cffunction>

<cffunction name="setContentBean" output="false" returntype="any">
	<cfargument name="contentBean">
	<cfif isObject(arguments.contentBean)>
		<cfset variables.instance.contentBean=arguments.contentBean>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="getEvent" output="false" returntype="any">
	<cfif not isObject(variables.instance.event)>
		<cfif structKeyExists(request,"servletEvent")>
			<cfset variables.instance.event=request.serlvetEvent>
		<cfelseif structKeyExists(request,"event")>
			<cfset variables.instance.event=request.event>
		</cfif>
	</cfif>
	<cfreturn variables.instance.event>
</cffunction>

<cffunction name="setEvent" output="false" returntype="any">
	<cfargument name="event">
	<cfif isObject(arguments.event)>
		<cfset variables.instance.event=arguments.event>
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="OnMissingMethod" access="public" returntype="any" output="false" hint="Handles missing method exceptions.">
<cfargument name="MissingMethodName" type="string" required="true" hint="The name of the missing method." />
<cfargument name="MissingMethodArguments" type="struct" required="true"/>
	<cfset var theValue="">
	<cfset var object="">
	
	<cfif len(MissingMethodName)>
		
		<cfif isObject(getEvent()) and structKeyExists(variables.instance.event,MissingMethodName)>
			<cfset object=variables.instance.event>
		<cfelseif isObject(getContentRenderer()) and structKeyExists(variables.instance.contentRenderer,MissingMethodName)>
			<cfset object=variables.instance.contentRenderer>
		<cfelseif isObject(getContentBean()) and structKeyExists(variables.instance.content,MissingMethodName)>
			<cfset object=variables.instance.contentBean>
		<cfelse>
			<cfthrow message="The method '#arguments.MissingMethodName#' is not defined">
		</cfif>
	
		<cfif not structIsEmpty(MissingMethodArguments)>
			<cfinvoke component="#object#" method="#MissingMethodName#" argumentcollection="#MissingMethodArguments#" returnvariable="theValue">
		<cfelse>
			<cfinvoke component="#object#" method="#MissingMethodName#" returnvariable="theValue">
		</cfif>
		
		<cfif isDefined("theValue")>
			<cfreturn theValue>
		<cfelse>
			<cfreturn "">
		</cfif>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>

<cffunction name="event" output="false" returntype="any">
	<cfargument name="property">
	<cfargument name="propertyValue">
	
	<cfif structKeyExists(arguments,"property")>
		<cfif isObject(getEvent())>
			<cfif structKeyExists(arguments,"propertyValue")>
				<cfset variables.instance.event.setValue(arguments.property,arguments.propertyValue)>
			</cfif>
			<cfreturn variables.instance.event.getValue(arguments.property)>
		<cfelse>
			<cfthrow message="The event is not set in the Mura Scope.">
		</cfif>
	<cfelse>
		<cfreturn variables.instance.event>
	</cfif>
	
</cffunction>

<cffunction name="content" output="false" returntype="any">
	<cfargument name="property">
	<cfargument name="propertyValue">
	
	<cfif structKeyExists(arguments,"property")>
		<cfif isObject(getContentBean())>
		<cfif structKeyExists(arguments,"propertyValue")>
			<cfset variables.instance.contentBean.setValue(arguments.property,arguments.propertyValue)>
		</cfif>
		<cfreturn  variables.instance.contentBean.getValue(arguments.property)>
		<cfelse>
			<cfthrow message="The content is not set ine the Mura Scope.">
		</cfif>
	<cfelse>
		<cfreturn variables.instance.content>
	</cfif>
</cffunction>

<cffunction name="currentUser" output="false" returntype="any">
	<cfargument name="property">
	<cfargument name="propertyValue">
	
	<cfif structKeyExists(arguments,"property")>
		<cfif structKeyExists(arguments,"propertyValue")>
			<cfset getCurrentUser().setValue(arguments.property,arguments.propertyValue)>
		</cfif>
		<cfreturn getCurrentUser().getValue(arguments.property)>
	<cfelse>
		<cfreturn getCurrentUser()>
	</cfif>
	
</cffunction>

<cffunction name="siteConfig" output="false" returntype="any">
	<cfargument name="property">
	<cfargument name="propertyValue">
	<cfset var site="">
	<cfset var theValue="">
	<cfset siteID=event('siteid')>
	
	<cfif len(siteid)>
		<cfset site=application.settingsManager.getSite(siteid)>
	
		<cfif structKeyExists(arguments,"property")>
			<cfif structKeyExists(arguments,"propertyValue")>
				<cfif structKeyExists(site,"set#arguments.property#")>
					<cfinvoke component="#site#" method="set#arguments.property#">
						<cfinvokeargument name="#arguments.property#" value="#arguments.propertyValue#">
					</cfinvoke>
				<cfelse>
					<cfthrow message="'#arguments.property#' is not a valid site property.">
				</cfif>
			</cfif>
			<cfif structKeyExists(site,"get#arguments.property#")>
				<cfinvoke component="#site#" method="get#arguments.property#" returnvariable="theValue">
			</cfif>
			<cfreturn theValue>
		<cfelse>
			<cfreturn site>
		</cfif>
	<cfelse>
		<cfthrow message="The siteid is not set in the current Mura Scope event.">
	</cfif>
	
</cffunction>

<cffunction name="globalConfig" output="false" returntype="any">
	<cfargument name="property">
	<cfset var site="">
	<cfset var theValue="">
	
	<cfif structKeyExists(arguments,"property")>
		<cfif structKeyExists(arguments,"propertyValue")>
				<cfif structKeyExists(application.configBean,"set#arguments.property#")>
					<cfinvoke component="#application.configBean#" method="set#arguments.property#">
						<cfinvokeargument name="#arguments.property#" value="#arguments.propertyValue#">
					</cfinvoke>
				<cfelse>
					<cfthrow message="'#arguments.property#' is not a valid global property.">
				</cfif>
			</cfif>
		<cfif structKeyExists(application.configBean,"get#arguments.property#")>
			<cfinvoke component="#application.configBean#" method="get#arguments.property#" returnvariable="theValue">
		</cfif>
		<cfreturn theValue>
	<cfelse>
		<cfreturn application.configBean>
	</cfif>
	
</cffunction>

<cffunction name="component" output="false" returntype="any">
	<cfargument name="property">
	<cfargument name="propertyValue">
	<cfset var componentBean="">
	<cfset var component=event('component')>
	
	<cfif structKeyExists(arguments,"property") and isStruct(component)>
		<cfif structKeyExists(arguments,"property") and structKeyExists(component,arguments.property)>
			
			<cfif structKeyExists(arguments,"propertyValue")>
				<cfset component[arguments.property]=arguments.propertyValue>
			</cfif>
			
			<cfreturn component[arguments.property]>
		<cfelse>
			<cfreturn "">
		</cfif>
	<cfelseif isStruct(component)>
		<cfset componentBean=getBean("content")>
		<cfset componentBean.setAllValues(component)>
		<cfreturn componentBean>
	<cfelse>
		<cfthrow message="No component has been set in the Mura Scope.">
	</cfif>
	
</cffunction>

<cffunction name="currentURL" output="false" returntype="any">
	<cfreturn getContentRenderer().getCurrentURL()>
</cffunction>

<cffunction name="getParent" output="false" returntype="any">
	<cfset var parent="">
	
	<cfif structKeyExists(request,"crumbdata") and arrayLen(request.crumbdata) gt 1>
		<cfreturn createObject("component","mura.content.contentNavBean").init(request.crumbdata[2], getBean("contentManager"),"active") />
	<cfelseif isObject(getContentBean())>
		<cfreturn getContentBean().getParent()>
	<cfelse>
		<cfthrow message="No primary content has been set.">
	</cfif>
</cffunction>

<cffunction name="getBean" returntype="any" access="public" output="false">
	<cfargument name="beanName">
	<cfargument name="siteID" required="false">
	
	<cfif structKeyExists(arguments,"siteid")>
		<cfreturn super.getBean(arguments.beanName,arguments.siteID)>
	<cfelse>
		<cfreturn super.getBean(arguments.beanName,event('siteid'))>
	</cfif>
</cffunction>

</cfcomponent>