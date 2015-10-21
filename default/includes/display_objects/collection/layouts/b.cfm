<cfoutput>
<div class="mura-collection layout-b">				
	<cfloop condition="iterator.hasNext()">
	<cfsilent>
		<cfset item=arguments.iterator.next()>
	</cfsilent>
	<div class="mura-collection-item" data-contentid="#esapiEncode('html_attr',item.getContentID())#" data-contenthistid="#esapiEncode('html_attr',item.getContentHistID())#" data-siteid="#esapiEncode('html_attr',item.getSiteID())#">
		
		<div class="mura-collection-item__holder">
			
			<div class="mura-item-content">
				<cfif item.hasImage()>
					<a href="#item.getURL()#"><img src="#item.getImageURL(height=300,width=500)#"></a>
				</cfif>
			</div>

			#variables.$.dspObject_include(
				theFile='collection/dsp_meta_list.cfm', 
				propertyMap=arguments.propertyMap, 
				item=item, 
				fields=arguments.objectParams.displaylist
			)#
		
		</div>
	</div>
	</cfloop>	
</div>
</cfoutput>