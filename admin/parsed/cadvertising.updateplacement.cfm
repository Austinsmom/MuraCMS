<cfsetting enablecfoutputonly="true" />
<cfprocessingdirective pageencoding="utf-8" />
<!--- circuit: cAdvertising --->
<!--- fuseaction: updatePlacement --->
<cftry>
<cfset myFusebox.thisPhase = "requestedFuseaction">
<cfset myFusebox.thisCircuit = "cAdvertising">
<cfset myFusebox.thisFuseaction = "updatePlacement">
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfif not isDefined("attributes.keywords")><cfset attributes.keywords = "" /></cfif>
<cfif not isDefined("attributes.date1")><cfset attributes.date1 = "" /></cfif>
<cfif not isDefined("attributes.date2")><cfset attributes.date2 = "" /></cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cfset application.utility.backUp() >
</cfif>
<cfif (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not application.permUtility.getModulePerm('00000000000000000000000000000000006','#attributes.siteid#')>
<cflocation url="#cgi.HTTP_REFERER#" addtoken="false">
<cfabort>
</cfif>
<cfif attributes.action eq 'Update'>
<cfset request.placementBean = application.advertiserManager.updatePlacement(attributes) >
</cfif>
<cfif attributes.action eq 'Delete'>
<cfset application.advertiserManager.deletePlacement(attributes.placementid) >
</cfif>
<cfif attributes.action eq 'Add'>
<cfset request.placementBean = application.advertiserManager.createPlacement(attributes) >
</cfif>
<cfif attributes.action eq 'Add' and structIsEmpty(request.placementBean.getErrors())>
<cfset attributes.placementid = "#request.placementBean.getplacementID()#" />
</cfif>
<cfif attributes.action neq  'delete' and not structIsEmpty(request.placementBean.getErrors())>
<!--- do action="cAdvertising.editPlacement" --->
<cfset myFusebox.thisFuseaction = "editPlacement">
<cfif not isDefined("attributes.startrow")><cfset attributes.startrow = "1" /></cfif>
<cfif not isDefined("attributes.keywords")><cfset attributes.keywords = "" /></cfif>
<cfif not isDefined("attributes.date1")><cfset attributes.date1 = "" /></cfif>
<cfif not isDefined("attributes.date2")><cfset attributes.date2 = "" /></cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cflocation url="index.cfm?fuseaction=cLogin.main&returnURL=#urlEncodedFormat('index.cfm?#cgi.query_string#')#" addtoken="false">
<cfabort>
</cfif>
<cfif not isUserInRole('S2IsPrivate')>
<cfset application.utility.backUp() >
</cfif>
<cfif (not isUserInRole('Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') and not isUserInRole('S2')) and not application.permUtility.getModulePerm('00000000000000000000000000000000006','#attributes.siteid#')>
<cflocation url="#cgi.HTTP_REFERER#" addtoken="false">
<cfabort>
</cfif>
<cfset request.userBean = application.userManager.read(attributes.userid) >
<cfset request.campaignBean = application.advertiserManager.readCampaign(attributes.campaignid) >
<cfset request.placementBean = application.advertiserManager.readPlacement(attributes.placementid) >
<cfset request.rsAdZones = application.advertiserManager.getadzonesBySiteID(attributes.siteid,'') >
<cfset request.rsCreatives = application.advertiserManager.getCreativesByUser(attributes.userid,'') >
<!--- do action="vAdvertising.editPlacement" --->
<cfset myFusebox.thisCircuit = "vAdvertising">
<cfsavecontent variable="fusebox.layout">
<cfif not isDefined("attributes.date1")><cfset attributes.date1 = "" /></cfif>
<cfif not isDefined("attributes.date2")><cfset attributes.date2 = "" /></cfif>
<cfif not isDefined("attributes.keywords")><cfset attributes.keywords = "" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/vAdvertising/dsp_editPlacement.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 21 and right(cfcatch.MissingFileName,21) is "dsp_editPlacement.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse dsp_editPlacement.cfm in circuit vAdvertising which does not exist (from fuseaction vAdvertising.editPlacement).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
</cfsavecontent>
<!--- do action="layout.display" --->
<cfset myFusebox.thisCircuit = "layout">
<cfset myFusebox.thisFuseaction = "display">
<cfif not isDefined("fusebox.ajax")><cfset fusebox.ajax = "" /></cfif>
<cfif not isDefined("fusebox.layout")><cfset fusebox.layout = "" /></cfif>
<cftry>
<cfoutput><cfinclude template="../view/layouts/template.cfm"></cfoutput>
<cfcatch type="missingInclude"><cfif len(cfcatch.MissingFileName) gte 12 and right(cfcatch.MissingFileName,12) is "template.cfm">
<cfthrow type="fusebox.missingFuse" message="missing Fuse" detail="You tried to include a fuse template.cfm in circuit layout which does not exist (from fuseaction layout.display).">
<cfelse><cfrethrow></cfif></cfcatch></cftry>
<cfset myFusebox.thisCircuit = "cAdvertising">
<cfset myFusebox.thisFuseaction = "updatePlacement">
<cfelse>
<cflocation url="index.cfm?fuseaction=cAdvertising.editCampaign&siteid=#attributes.siteid#&userid=#attributes.userid#&campaignid=#attributes.campaignid#" addtoken="false">
<cfabort>
</cfif>
<cfcatch><cfrethrow></cfcatch>
</cftry>

