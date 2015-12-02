<cfoutput>
<link href="#variables.$.globalConfig('adminPath')#/assets/css/layoutmanager.css" rel="stylesheet" type="text/css" />

<div class="mura__layout-manager__controls">
					
	<div class="mura__layout-manager__controls__scrollable">
	
		<div class="mura__layout-manager__controls__objects">
	
			<div id="mura-sidebar-objects" class="mura-sidebar__objects-list">
			 	<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<cfif $.content('type') neq 'Variation'>
						<a href="##" id="mura-objects-legacy-btn">View Legacy Objects</a>
						</cfif>
						<h3>Content Objects</h3>
					</div>
					<div class="mura-sidebar__objects-list__object-group-items">
						<cfset contentRendererUtility=$.getBean('contentRendererUtility')>

						#contentRendererUtility.renderObjectClassOption(
							object='container',
							objectid='',
							objectname='Container'
						)#

						#contentRendererUtility.renderObjectClassOption(
							object='collection',
							objectid='',
							objectname='Collection'
						)#

						#contentRendererUtility.renderObjectClassOption(
							object='text',
							objectid='',
							objectname='Text'
						)#

						#contentRendererUtility.renderObjectClassOption(
							object='embed',
							objectid='',
							objectname='Embed'
						)#

						#contentRendererUtility.renderObjectClassOption(
							object='form',
							objectid='',
							objectname='Form'
						)#

						<cfif $.content('type') neq 'Variation'>
							#contentRendererUtility.renderObjectClassOption(
								object='navigation',
								objectid='',
								objectname='Navigation'
							)#

							#contentRendererUtility.renderObjectClassOption(
								object='system',
								objectid='',
								objectname='System Object'
							)#

							#contentRendererUtility.renderObjectClassOption(
								object='mailing_list',
								objectid='',
								objectname='Mailing List'
							)#
						</cfif>

						#contentRendererUtility.renderObjectClassOption(
							object='plugin',
							objectid='',
							objectname='Plugin'
						)#
						

					</div>
				</div>
			</div>
			<cfif $.content('type') neq 'Variation'>
			<div id="mura-sidebar-objects-legacy" class="mura-sidebar__objects-list" style="display:none">
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<a href="##" class="mura-objects-back-btn">&lt Back</a>
						<h3>Legacy Objects</h3>
					</div>
					<div class="mura-sidebar__objects-list__object-group-items">
						<select name="classSelector" onchange="mura.loadObjectClass('#esapiEncode("Javascript",$.content('siteid'))#',this.value,'','#$.content('contenthistid')#','#$.content('parentid')#','#$.content('contenthistid')#',0);">
						<option value="">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectobjecttype')#</option>
			            <cfif application.settingsManager.getSite($.event('siteid')).getemailbroadcaster()>
			                <option value="mailingList">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.mailinglists')#</option>
			            </cfif> 
		                <cfif application.settingsManager.getSite($.event('siteid')).getAdManager()>
		                  <option value="adzone">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.adregions')#</option>
		                </cfif>
		                <!--- <option value="category">Categories</option> --->
		                <option value="folder">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.Folders')#</option>
		                <option value="calendar">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.calendars')#</option>
		                <option value="gallery">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.galleries')#</option>
		                <option value="component">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.components')#</option>
		                <cfif application.settingsManager.getSite($.event('siteid')).getHasfeedManager()>
		                  <option value="localFeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexes')#</option>
		                  <option value="slideshow">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindexslideshows')#</option>
		                  <option value="remoteFeed">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeeds')#</option>
		                </cfif>
		              </select>

					</div>
				</div>

				<div id="classListContainer" class="mura-sidebar__objects-list__object-group" style="display:none">
					<div class="mura-sidebar__objects-list__object-group-heading">
						Select Object
					</div>
					<div class="mura-sidebar__object-group-items" id="classList"></div>
				</div>
		
			</div>
			</cfif>
			
			<div id="mura-sidebar-configurator" style="display:none">
				<!---
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
					<a href="##" class="mura-objects-back-btn">&lt Back</a>
					</div>
				</div>
				--->
				<iframe src="" id="frontEndToolsSidebariframe" scrolling="false" frameborder="0" style="overflow:hidden" name="frontEndToolsSidebariframe">
				</iframe>
			
			</div>
			
			<div id="mura-sidebar-editor" style="display:none">
				<div class="mura-sidebar__objects-list__object-group">
					<div class="mura-sidebar__objects-list__object-group-heading">
						<h3>Editing Content</h3>
						<a href="javascript:" class="mura-objects-back-btn" id="mura-deactivate-editors">Done Editing</a>
					</div>
				</div>

				<div id="classListContainer" class="mura-sidebar__objects-list__object-group" style="display:none">
					<div class="mura-sidebar__objects-list__object-group-heading">
						Select Object
					</div>
					<div class="mura-sidebar__object-group-items" id="classList"></div>
				</div>
		
			</div>
		</div>
	</div>
	
</div>

<script>
mura.ready(function(){
	mura('##mura-objects-legacy-btn').click(function(e){
		e.preventDefault();
		muraInlineEditor.sidebarAction('showlegacyobjects');
	});

	mura('.mura-objects-back-btn').click(function(e){
		e.preventDefault();
		muraInlineEditor.sidebarAction('showobjects');
	});

	mura.adminpath='#variables.$.globalConfig("adminPath")#';
	mura.loader().loadjs('#variables.$.globalConfig("adminpath")#/assets/js/layoutmanager.js');
});
</script>
</cfoutput>


