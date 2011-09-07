﻿<!--- This file is part of Mura CMS.

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
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (GPL) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the /trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 without this exception. You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfset $=application.serviceFactory.getBean("muraScope").init(attributes.siteID)>
<cfset feed=$.getBean("feed").loadBy(feedID=attributes.feedID)>

<cfif isDefined("form.params") and isJSON(form.params)>
	<cfset feed.set(deserializeJSON(form.params))>
</cfif>

<cfset data=structNew()>
<cfsavecontent variable="data.html">
<cfoutput>

			<div id="availableObjectParams"<!--- style="display:none;"--->>
		
			<cfif feed.getType() eq "local">		
				<dl class="oneColumn" id="configurator">
					<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.imagesize')#</dt>
					<dd><select data-displayobjectparam="imageSize" class="dropdown" onchange="if(this.value=='Custom'){jQuery('##feedCustomImageOptions').fadeIn('fast')}else{jQuery('##feedCustomImageOptions').hide()}">
						<cfloop list="Small,Medium,Large,Custom" index="i">
							<option value="#lcase(i)#"<cfif i eq feed.getImageSize()> selected</cfif>>#I#</option>
						</cfloop>
						</select>
					</dd>
					<dd id="feedCustomImageOptions"<cfif feed.getImageSize() neq "Custom"> style="display:none"</cfif>>
						<dl>
							<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imageheight')#</dt>
							<dd><input data-displayobjectparam="imageHeight" class="text" value="#feed.getImageHeight()#" /></dd>
							<dt>#application.rbFactory.getKeyValue(session.rb,'collections.imagewidth')#</dt>
							<dd><input data-displayobjectparam="imageWidth" class="text" value="#feed.getImageWidth()#" /></dd>
						</dl>
					</dd>
				
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.displayname')#</dt>
				<dd>
				<input name="feedDisplayName" data-displayobjectparam="displayName" type="radio" value="1" class="radio" onchange="jQuery('##altNameContainer').toggle();"<cfif feed.getDisplayName()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
				<input name="feedDisplayName" data-displayobjectparam="displayName" type="radio" value="0" class="radio" onchange="jQuery('##altNameContainer').toggle();" <cfif not feed.getDisplayName()>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
				</dd>
				<span id="altNameContainer"<cfif NOT feed.getDisplayName()> style="display:none;"</cfif>>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.altname')#</dt>
				<dd><input data-displayobjectparam="altName" class="text" value="#HTMLEditFormat(feed.getAltName())#" maxlength="50"></dd>
				</span>
				<dt>Fields to Output</dt>
				<dd>
					<div>
		
					<cfset displayList=feed.getDisplayList()>
					<cfset availableList=feed.getAvailableList()>
					
					<ul id="availableListSort" class="displayListSortOptions">
						<cfloop list="#availableList#" index="i">
						<li class="ui-state-default">#i#</li>
						</cfloop>
					</ul>
					
					<ul id="displayListSort" class="displayListSortOptions">
						<cfloop list="#displayList#" index="i">
						<li class="ui-state-highlight">#i#</li>
						</cfloop>
					</ul>
					<input type="hidden" id="displayList" value="#displayList#" data-displayobjectparam="displayList"/>
					</div>	
				</dd>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.itemsperpage')#</dt>
				<dd><select data-displayobjectparam="nextN" class="dropdown">
					<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="r">
					<option value="#r#" <cfif r eq feed.getNextN()>selected</cfif>>#r#</option>
					</cfloop>
					<option value="100000" <cfif feed.getNextN() eq 100000>selected</cfif>>ALL</option>
					</select>
				</dd>
				<dt>#application.rbFactory.getKeyValue(session.rb,'collections.maxitems')#</dt>
				<dd><select data-displayobjectparam="maxItems" class="dropdown">
				<cfloop list="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,25,50,100" index="m">
				<option value="#m#" <cfif feed.getMaxItems() eq m>selected</cfif>>#m#</option>
				</cfloop>
				<option value="100000" <cfif feed.getMaxItems() eq 100000>selected</cfif>>ALL</option>
				</select>
				</dd>
				</dl>
			</div>
				<input type="hidden" name="displayObjectTemplate" id="displayObjectTemplate" value="{'object':'feed','name':'#JSStringFormat('#feed.getName()# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.localindex')#')#','objectid':'#feed.getFeedID()#'}"/>
			<cfelse>
				<cfset displaySummaries=yesNoFormat(feed.getValue("displaySummaries"))>
				<dl class="oneColumn">
		
				<dt class="first">#application.rbFactory.getKeyValue(session.rb,'collections.displaysummaries')#</dt>
				<dd>
				<input name="feedDisplaySummaries" data-displayobjectparam="displaySummaries" type="radio" value="1" class="radio" onchange="jQuery('##altNameContainer').toggle();"<cfif displaySummaries>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.yes')# 
				<input name="feedDisplaySummaries" data-displayobjectparam="displaySummaries" type="radio" value="0" class="radio" onchange="jQuery('##altNameContainer').toggle();" <cfif not displaySummaries>checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'collections.no')# 
				</dd>
				</dl>
			</div>
				<input type="hidden" name="displayObjectTemplate" id="displayObjectTemplate" value="{'object':'feed','name':'#JSStringFormat('#feed.getName()# - #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.remotefeed')#')#','objectid':'#feed.getFeedID()#'}"/>
			</cfif>
</cfoutput>
</cfsavecontent>
<cfset data.type=feed.getType()>
<cfoutput>#createObject("component","mura.json").encode(data)#</cfoutput>
<cfabort>
