<!---
	This file is part of Mura CMS.

	Mura CMS is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, Version 2 of the License.

	Mura CMS is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

	Linking Mura CMS statically or dynamically with other modules constitutes 
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<cfcomponent extends="mura.cfobject">

	<cfscript>
/**	
* @parentID Category ParentID
*/
public any function dspNestedCategories(
	string siteid='#variables.$.event('siteid')#'
	, string parentID=''
	, string keywords=''
	, boolean activeOnly=false
	, boolean InterestsOnly=false
	, boolean showCategoryKids=true
) {
	var local = {};
	local.str = '';
	local.gateway = variables.$.getBean('categoryGateway');
	local.rs = local.gateway.getCategories(argumentCollection=arguments);
	local.it = variables.$.getBean('categoryIterator').setQuery(local.rs);

	if ( local.it.hasNext() ) {
		savecontent variable='local.str' {
			WriteOutput('<ul>');
				While ( local.it.hasNext() ) {
					local.item = local.it.next();

					// If allows content assignments, then create a link
					if ( local.item.getIsOpen() ) {
						local.itemCategoryURL = variables.$.createHREF(
							filename = variables.$.event('currentFilenameAdjusted') 
								& '/category/' 
								& local.item.getFilename()
						);
						WriteOutput('<li>
							<a href="#local.itemCategoryURL#">
								#HTMLEditFormat(local.item.getName())#
							</a>
						');
					} else {
						WriteOutput('<li>#HTMLEditFormat(local.item.getName())#');
					}

						// Show Child Categories?
						if ( arguments.showCategoryKids ) {
							local.rsKids = local.gateway.getCategories(
								siteID=local.item.getSiteID()
								, parentID=local.item.getCategoryID()
							);
							if ( local.rsKids.recordcount ) {
								local.itKids = variables.$.getBean('categoryIterator').setQuery(local.rsKids);
								While ( local.itKids.hasNext() ) {
									local.kid = local.itKids.next();
									WriteOutput('<ul>
										<li>');

									// If allows content assignments, then create a link
									if ( local.kid.getIsOpen() ) {
										local.kidCategoryURL = variables.$.createHREF(
											filename = variables.$.event('currentFilenameAdjusted') 
												& '/category/' 
												& local.kid.getFilename()
										);
										WriteOutput('
											<a href="#local.kidCategoryURL#">
												#HTMLEditFormat(local.kid.getName())#
											</a>
										');
									} else {
										WriteOutput('#HTMLEditFormat(local.kid.getName())#');
									}

									WriteOutput('#dspNestedCategories(parentID=local.kid.getCategoryID())#
										</li>
									</ul>');
								}
							}
						} // @end showCategoryKids
					WriteOutput('</li>');
				}
			WriteOutput('</ul>');
		}
	} // @end local.it.hasNext()
	return local.str;
}
</cfscript>


	<!---
			This is the THEME contentRenderer.cfc

			* Add theme-specific methods here
			* Any methods here will be accessible with the following notation:
				$.yourFunctionName()
	--->

	<cffunction name="dspCarouselByFeedName" output="false">
		<cfargument name="feedName" type="string" default="Slideshow" />
		<cfargument name="showCaption" type="boolean" default="true" />
		<cfargument name="cssID" type="string" default="myCarousel" />
		<cfargument name="size" type="string" default="custom" hint="If you want to use a custom height/width, then use 'custom' ... otherwise, you can use 'small, medium, large' OR any other predefined custom image size 'name' you created via the back-end administrator." />
		<cfargument name="width" type="numeric" default="1280" hint="width in pixels" />
		<cfargument name="height" type="numeric" default="500" hint="height in pixels" />
		<cfargument name="interval" type="any" default="5000" hint="Use either milliseconds OR use 'false' to NOT auto-advance to next slide." />
		<cfargument name="autoStart" type="boolean" default="true" />
		<cfargument name="showIndicators" type="boolean" default="true" />
		<cfscript>
			var local = {};
			local.imageArgs = {};

			if ( not ListFindNoCase('small,medium,large,custom', arguments.size) and variables.$.getBean('imageSize').loadBy(name=arguments.size,siteID=variables.$.event('siteID')).getIsNew() ) {
				arguments.size = 'custom';
			};

			if ( not Len(Trim(arguments.size)) or LCase(arguments.size) eq 'custom' ) {
				local.imageArgs.width = Val(arguments.width);
				local.imageArgs.height = Val(arguments.height);
			} else {
				local.imageArgs.size = arguments.size;
			};
		</cfscript>
		<cfsavecontent variable="local.str"><cfoutput>
			<!--- BEGIN: Bootstrap Carousel --->
			<!--- IMPORTANT: This will only output items that have associated images --->
			<cfset local.feed = variables.$.getBean('feed').loadBy(name=arguments.feedName)>
			<cfset local.iterator = local.feed.getIterator()>
			<cfif local.iterator.hasNext()>
				<div id="#arguments.cssID#" class="carousel slide" data-interval="#arguments.interval#">

					<!--- Indicators --->
					<cfif arguments.showIndicators>
						<ol class="carousel-indicators">
							<cfset local.iterator.reset()>
							<cfset local.idx = 0>
							<cfloop condition="local.iterator.hasNext()">
								<cfset local.item=iterator.next()>
								<cfif ListFindNoCase('jpg,jpeg,gif,png', ListLast(local.item.getImageURL(), '.'))>
									<li data-target="###arguments.cssID#" data-slide-to="#idx#" class="<cfif local.idx eq 0>active</cfif>"></li>
									<cfset local.idx++>
								</cfif>
							</cfloop>
						</ol>
					</cfif>

					<!--- Wrapper for slides --->
					<div class="row carousel-inner">
						<cfset local.iterator.reset()>
						<cfset local.idx = 0>
						<cfloop condition="local.iterator.hasNext()">
							<cfset local.item=iterator.next()>
							<cfif ListFindNoCase('jpg,jpeg,gif,png', ListLast(local.item.getImageURL(), '.'))>
								<div class="row item<cfif local.idx eq 0> active</cfif>">
									<img src="#local.item.getImageURL(argumentCollection=local.imageArgs)#" alt="#HTMLEditFormat(local.item.getTitle())#">
									<cfif arguments.showCaption>
										<div class="container">
											<div class="carousel-caption">
												<h3><a href="#local.item.getURL()#">#HTMLEditFormat(local.item.getTitle())#</a></h3>
												#local.item.getSummary()#
												<p><a class="btn btn-larg btn-primary" href="#local.item.getURL()#">Read More</a></p>
											</div>
										</div>
									</cfif>
								</div>
								<cfset local.idx++>
							</cfif>
						</cfloop>
					</div>

					<cfif local.idx>
						<!--- Controls --->
						<cfif local.idx gt 1>
							<a class="left carousel-control" href="###arguments.cssID#" data-slide="prev"><span class="glyphicon glyphicon-chevron-left"></span></a>
							<a class="right carousel-control" href="###arguments.cssID#" data-slide="next"><span class="glyphicon glyphicon-chevron-right"></span></a>
							<!--- AutoStart --->
							<cfif arguments.autoStart>
								<script>jQuery(document).ready(function($){$('###arguments.cssID#').carousel({interval:#arguments.interval#});});</script>
							</cfif>
						</cfif>
					<cfelse>
						<div class="alert alert-info alert-block">
							<button type="button" class="close" data-dismiss="alert"><i class="icon-remove"></i></button>
							<h4>Oh snap!</h4>
							Your feed has no items <em>with images</em>.
						</div>
					</cfif>
				</div>
			<cfelse>
				<div class="alert alert-info alert-block">
					<button type="button" class="close" data-dismiss="alert"><i class="icon-remove"></i></button>
					<h4>Heads up!</h4>
					Your feed has no items.
				</div>
			</cfif>
			<!--- // END: Bootstrap Carousel --->
		</cfoutput></cfsavecontent>
		<cfreturn local.str />
	</cffunction>

</cfcomponent>