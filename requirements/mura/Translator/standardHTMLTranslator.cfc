<cfcomponent extends="Translator" output="false">
	
<cffunction name="translate" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset var page = "" />
	<cfset var renderer=event.getValue("contentRenderer") />
	
	<cfset application.pluginManager.executeScripts('onRenderStart',event.getValue('siteID'), event)/>
	
	<cfsavecontent variable="page">
		<cfinclude template="/#application.configBean.getWebRootMap()#/#event.getValue('siteID')#/includes/templates/#renderer.getTemplate()#">
	</cfsavecontent>
		
	<cfif (event.getValue('forceSSL') or (event.getValue('r').restrict and application.settingsManager.getSite(event.getValue('siteID')).getExtranetSSL() eq 1)) and listFindNoCase('Off,False',cgi.https)>
		<cflocation addtoken="no" url="https://#application.settingsManager.getSite(event.getValue('siteID')).getDomain()##application.configBean.getServerPort()##renderer.getCurrentURL(false)#">
	</cfif>
	
	<cfif not (event.getValue('r').restrict or event.getValue('forceSSL')) and listFindNoCase('On,True',cgi.https)>
		<cflocation addtoken="no" url="http://#application.settingsManager.getSite(event.getValue('siteID')).getDomain()##application.configBean.getServerPort()##renderer.getCurrentURL(false)#">
	</cfif>
			
	<cfset renderer.renderHTMLHeadQueue() />
	<cfset event.setValue('__MuraResponse__',page)>
</cffunction>

</cfcomponent>