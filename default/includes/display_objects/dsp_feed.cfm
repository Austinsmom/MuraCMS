<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. �See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. �If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (�GPL�) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, �the copyright holders of Mura CMS grant you permission
to combine Mura CMS �with independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the �/trunk/www/plugins/ directory through the Mura CMS
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
the GNU General Public License version 2 �without this exception. �You may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->


<!--- <cftry> --->
  <cfif isValid("UUID",arguments.objectID)>	
	<cfset variables.feedBean = $.getBean("feed").loadBy(feedID=arguments.objectID,siteID=arguments.siteID)>
  <cfelse>
	<cfset variables.feedBean = $.getBean("feed").loadBy(name=arguments.objectID,siteID=arguments.siteID)>
  </cfif>

  <cfif variables.feedBean.getIsActive()>
	<cfset variables.cssID=createCSSid(feedBean.renderName())>
    
	<cfset editableControl.editLink = "">
	<cfset editableControl.innerHTML = "">
	
	<cfif not variables.feedBean.getIsNew() and this.showEditableObjects and arguments.objectPerm eq 'editor'>
		<cfset bean = feedBean>
		<cfset loadShadowBoxJS()>
		<cfset addToHTMLHeadQueue('editableObjects.cfm')>
		<cfif len(application.configBean.getAdminDomain())>
			<cfif application.configBean.getAdminSSL()>
				<cfset variables.adminBase="https://#application.configBean.getAdminDomain()#"/>
			<cfelse>
				<cfset variables.adminBase="http://#application.configBean.getAdminDomain()#"/>
			</cfif>
		<cfelse>
			<cfset variables.adminBase=""/>
		</cfif>
		
		<cfset editableControl.editLink = adminBase & "#application.configBean.getContext()#/admin/index.cfm?fuseaction=cFeed.edit">
		<cfset editableControl.editLink = editableControl.editLink & "&amp;siteid=" & bean.getSiteID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;feedid=" & bean.getFeedID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;type=" & bean.getType()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;homeID=" & request.contentBean.getContentID()>
		<cfset editableControl.editLink = editableControl.editLink & "&amp;compactDisplay=true">
		
		<cfset editableControl.innerHTML = generateEditableObjectControl(editableControl.editLink)>
	</cfif>
	<cfif editableControl.innerHTML neq "">
		<cfoutput>#renderEditableObjectHeader("editableFeed")#</cfoutput>
	</cfif>
	
	<cfif variables.feedBean.getType() eq 'local'>
      <cfsilent>
		<cfset variables.rsPreFeed=application.feedManager.getFeed(feedBean) />
		<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
			<cfset variables.rs=queryPermFilter(rsPreFeed)/>
		<cfelse>
			<cfset variables.rs=rsPreFeed />
		</cfif>
		
		<cfset variables.iterator=application.serviceFactory.getBean("contentIterator")>
		<cfset variables.iterator.setQuery(rs,feedBean.getNextN())>
		<cfset variables.rbFactory=getSite().getRBFactory() />
		<cfset variables.checkMeta=feedBean.getDisplayRatings() or feedBean.getDisplayComments()>
		<cfset variables.doMeta=0 />
		<cfset event.setValue("currentNextNID",feedBean.getFeedID())>

		<cfif not len(event.getValue("nextNID")) or event.getValue("nextNID") eq event.getValue("currentNextNID")>
			<cfif event.getContentBean().getNextN() gt 1>
				<cfset variables.currentNextNIndex=event.getValue("startRow")>
				<cfset variables.iterator.setStartRow(currentNextNIndex)>
			<cfelse>
				<cfset variables.currentNextNIndex=event.getValue("pageNum")>
				<cfset variables.iterator.setPage(currentNextNIndex)>
			</cfif>
		<cfelse>	
			<cfset variables.currentNextNIndex=1>
			<cfset variables.iterator.setPage(1)>
		</cfif>
		
		<cfset variables.nextN=application.utility.getNextN(variables.rs,variables.feedBean.getNextN(),variables.currentNextNIndex)>
		
		<cfset variables.contentListType="Feed">
		<cfset variables.contentListFields="Title,Date,Image,Tags,Credits">
		
		<cfif arguments.hasSummary>
			<cfset variables.contentListFields=listAppend(variables.contentListFields,"Summary")>
		</cfif>
		
		<cfif variables.feedBean.getDisplayComments()>
			<cfset variables.contentListFields=listAppend(variables.contentListFields,"Comments")>
		</cfif>
		
		<cfif variables.feedBean.getDisplayRatings()>
			<cfset variables.contentListFields=listAppend(variables.contentListFields,"Rating")>
		</cfif>
	  </cfsilent>

		<cfif variables.iterator.getRecordCount()>
			<cfset addToHTMLHeadQueue("listImageStyles.cfm")>
			<cfoutput>
			<div class="svSyndLocal svFeed svIndex clearfix" id="#variables.cssID#">
	        <cfif variables.feedBean.getDisplayName()>
		       <#getHeaderTag('subHead1')#>#HTMLEditFormat(feedBean.renderName())#</#getHeaderTag('subHead1')#>
			</cfif>
			
			#dspObject_Include(
				thefile='dsp_content_list.cfm',
				fields=variables.contentListFields,
				type=variables.contentListType, 
				iterator= variables.iterator
				)#

			<cfif variables.nextN.numberofpages gt 1>
			#dspObject_Include(thefile='dsp_nextN.cfm')#
			</cfif>
			</div>
			</cfoutput>
		<cfelse>
			<cfoutput>#dspObject("component","[placeholder] #variables.feeBean.getName()#", arguments.siteID)#</cfoutput>
			<!-- Empty Collection '<cfoutput>#feedBean.getName()#</cfoutput>'  -->
		</cfif>
    <cfelse>
    <!---<cftry> --->
	<cfsilent>
		<cfset request.cacheItemTimespan=createTimeSpan(0,0,5,0)>
      	<cfset variables.feedData=application.feedManager.getRemoteFeedData(variables.feedBean.getChannelLink(),variables.feedBean.getMaxItems())/>
	</cfsilent>
	  	<cfoutput>
		 	<cfif isDefined("variables.feedData.maxItems") and variables.feedData.maxItems>
				<div class="svSyndRemote svIndex svFeed clearfix" id="#variables.cssID#">
			        <#getHeaderTag('subHead1')#>#HTMLEditFormat(variables.feedBean.getName())#</#getHeaderTag('subHead1')#>
			        <cfif variables.feedData.type neq "atom">
						<cfloop from="1" to="#variables.feedData.maxItems#" index="i">
							<dl<cfif (i EQ 1)> class="first"<cfelseif (i EQ variables.feedData.maxItems)> class="last"</cfif>>
								<!--- Date stuff--->
								<cfif structKeyExists(variables.feedData.itemArray[i],"pubDate")>
									<cftry>
									<cfset variables.itemDate=parseDateTime(variables.feedData.itemArray[i].pubDate.xmlText)>
									<dt class="releaseDate"><cfif isDate(variables.itemDate)>#LSDateFormat(variables.itemDate,getLongDateFormat())#<cfelse>#variables.feedData.itemArray[i].pubDate.xmlText#</cfif></dt>
									<cfcatch></cfcatch>
									</cftry>
								<cfelseif structKeyExists(variables.feedData.itemArray[i],"dc:date")>
									<cftry>
									<cfset itemDate=parseDateTime(variables.feedData.itemArray[i]["dc:date"].xmlText)>
									<dt class="releaseDate"><cfif isDate(variables.itemDate)>#LSDateFormat(variables.itemDate,getLongDateFormat())#<cfelse>#variables.feedData.itemArray[i]["dc:date"].xmlText#</cfif></dt>
									<cfcatch></cfcatch>
									</cftry>
								</cfif>
								<dt><a href="#variables.feedData.itemArray[i].link.xmlText#" onclick="window.open(this.href); return false;">#variables.feedData.itemArray[i].title.xmlText#</a></dt>						
								<cfif arguments.hasSummary and structKeyExists(variables.feedData.itemArray[i],"description")><dd class="summary">#variables.feedData.itemArray[i].description.xmlText#</dd></cfif>
							</dl>
						</cfloop>
					<cfelse>
						<cfloop from="1" to="#variables.feedData.maxItems#" index="i">
							<dl<cfif (i EQ 1)> class="first"<cfelseif (i EQ variables.feedData.maxItems)> class="last"</cfif>>
								<!--- Date stuff--->
								<cfif structKeyExists(variables.feedData.itemArray[i],"updated")>
									<cftry>
									<cfset variables.itemDate=parseDateTime(variables.feedData.itemArray[i].updated.xmlText)>
									<dt class="releaseDate"><cfif isDate(variables.itemDate)>#LSDateFormat(variables.itemDate,getLongDateFormat())#<cfelse>#variables.feedData.itemArray[i].updated.xmlText#</cfif></dt>
									<cfcatch></cfcatch>
									</cftry>
								</cfif>
								<dt><a href="#variables.feedData.itemArray[i].link.XmlAttributes.href#" onclick="window.open(this.href); return false;">#variables.feedData.itemArray[i].title.xmlText#</a></dt>
								<cfif arguments.hasSummary and structKeyExists(variables.feedData.itemArray[i],"summary")><dd class="summary">#variables.feedData.itemArray[i].summary.xmlText#</dd></cfif>
							</dl>
						</cfloop>
					</cfif>
				</div>
			<cfelse>
				#dspObject("component","[placeholder] #variables.feeBean.getName()#", arguments.siteID)#
				<!-- Empty Feed <cfoutput>'#feedBean.getName()#'</cfoutput> -->
			</cfif>
		</cfoutput>
	<!---
	<cfcatch><!-- Error getting Feed <cfoutput>'#feedBean.getName()#'</cfoutput> --></cfcatch>
	</cftry>---->
    </cfif>
  <cfelse>
		<!-- Inactive Feed '<cfoutput>#feedBean.getName()#</cfoutput>' -->
  </cfif>
  <cfif editableControl.innerHTML neq "">
  	<cfoutput>#renderEditableObjectFooter(editableControl.innerHTML)#</cfoutput>
  </cfif>
<!---   <cfcatch>
  </cfcatch>
</cftry> --->