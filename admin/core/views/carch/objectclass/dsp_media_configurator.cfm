
<cfset $=application.serviceFactory.getBean("muraScope").init(rc.siteID)>
<cfif isDefined("form.params") and isJSON(form.params)>
	<cfset objectParams=deserializeJSON(form.params)>
<cfelse>
	<cfset objectParams={}>
</cfif>
<cfparam name="objectParams.source" default="">
<cfset data=structNew()>
<cfsavecontent variable="data.html">
<cf_objectconfigurator params="#objectParams#">
<cfoutput>
<div id="availableObjectParams"
	data-object="media" 
	data-name="#esapiEncode('html_attr','#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.media')#')#" 
	data-objectid="none">
<div class="fieldset-wrap">
	<div class="fieldset">
		<div class="control-group">
			<label class="control-label">Enter Embed Code</label>
			<div class="controls">
				<textarea name="source" class="objectParam span12">#objectParams.source#</textarea>
				<input type="hidden" class="objectParam" name="render" value="client">
				<input type="hidden" class="objectParam" name="async" value="false">
				<input type="hidden" class="objectParam" name="clientTemplate" value="socialembed">
			</div>
		</div>
	</div>
</div>
</div>
</cfoutput>
</cf_objectconfigurator>
</cfsavecontent>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
<cfabort>