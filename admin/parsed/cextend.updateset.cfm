<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cExtend --->
<!--- fuseaction: updateSet --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cExtend">
<cfset myFusebox.thisFuseaction = "updateSet">
<cfif not isDefined("attributes.subTypeID")><cfset attributes.subTypeID = "" /></cfif>
<cfif not isDefined("attributes.extendSetID")><cfset attributes.extendSetID = "" /></cfif>
<cfif not isDefined("attributes.attibuteID")><cfset attributes.attibuteID = "" /></cfif>
<cfif not isDefined("attributes.siteID")><cfset attributes.siteID = "" /></cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('S2')>
<cflocation url="index.cfm" addtoken="false">
<cfabort>
</cfif>
<cfset request.extendSetBean = application.classExtensionManager.getSubTypeBean().getExtendSetBean() >
<cfset request.extendSetBean.set(attributes) >
<cfif attributes.action eq 'Update'>
<cfset request.extendSetBean.save() >
</cfif>
<cfif attributes.action eq 'Delete'>
<cfset request.extendSetBean.delete() >
</cfif>
<cfif attributes.action eq 'Add'>
<cfset request.extendSetBean.save() >
</cfif>
<cfif attributes.action neq 'delete'>
<cflocation url="index.cfm?fuseaction=cExtend.editAttributes&subTypeID=#attributes.subTypeID#&extendSetID=#attributes.extendSetID#&siteid=#attributes.siteid#" addtoken="false">
<cfabort>
<cfelse>
<cflocation url="index.cfm?fuseaction=cExtend.listSets&siteid=#attributes.siteid#&subTypeID=#attributes.subTypeID#" addtoken="false">
<cfabort>
</cfif>
<cfcatch><cfrethrow></cfcatch>
</cftry>

