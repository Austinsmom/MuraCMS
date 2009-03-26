<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. --->

<cfsilent>
<!---<cfset loadShadowBoxJS() />--->
	
<cfset categoryBean=application.categoryManager.read(listfirst(arguments.objectid)) />
<cfquery datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#" name="rsSection">select contentid,filename,menutitle,target,restricted,restrictgroups,type,sortBy,sortDirection from tcontent where siteid='#request.siteid#' and contentid='#listLast(arguments.objectid)#' and approved=1 and active=1 and display=1
</cfquery>

<cfif rsSection.recordcount and categoryBean.getIsActive()>
<cfset hasComments=application.contentGateway.getHasComments(request.siteid,rsSection.contentID) />
<cfset hasRatings=application.contentGateway.getHasRatings(request.siteid,rsSection.contentID) />
<cfset checkMeta=hasRatings or hasComments />
<cfset menutype=iif(rsSection.type eq 'Portal',de('default'),de('calendar_features'))/>
<cfset rsPreFeatures=application.contentGateway.getkids('00000000000000000000000000000000000','#request.siteid#','#rssection.contentid#',menutype,now(),0,"",1,iif(rsSection.type eq 'Portal',de('#rsSection.sortBy#'),de('displaystart')),iif(rsSection.type eq 'Portal',de('#rsSection.sortDirection#'),de('desc')),categoryBean.getCategoryID())>
	<cfif getSite().getExtranet() eq 1 and request.r.restrict eq 1>
		<cfset rsFeatures=queryPermFilter(rsPreFeatures)/>
	<cfelse>
		<cfset rsFeatures=rsPreFeatures/>
	</cfif>
</cfif>
<cfset rbFactory=getSite().getRBFactory() />
<cfparam name="hasSummary" default="true"/>
<cfset cssID="#createCSSID(rsSection.menuTitle & categoryBean.getName())#">
<cfset doMeta=0 />
</cfsilent>
<cfoutput>
<cfif rsSection.recordcount and categoryBean.getIsActive() and rsFeatures.recordcount>
<div class="svCatSecFeatures" id="#cssID#">
<h3>#rsSection.MenuTitle#</h3>
	<cfloop query="rsFeatures">
		<cfsilent>
			<cfset theLink=createHREF(rsFeatures.type,rsFeatures.filename,rsFeatures.siteid,rsFeatures.contentid,rsFeatures.target,rsFeatures.targetparams,"",application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile()) />
				<cfset class=""/>
				<cfif rsFeatures.currentRow eq 1> 
					<cfset class=listAppend(class,"first"," ")/> 
				</cfif>
				<cfif rsFeatures.currentRow eq rsFeatures.recordcount> 
					<cfset class=listAppend(class,"last"," ")/> 
				</cfif>
				
				<cfset hasImage=len(rsFeatures.fileID) and showImageInList(rsFeatures.fileExt) />

				<cfif hasImage>
					<cfset class=listAppend(class,"hasImage"," ")>
				</cfif>
				<cfif checkMeta> 
				<cfset doMeta=rsFeatures.type eq 'Page' or showItemMeta(rsFeatures.type) or (len(rsFeatures.fileID) and showItemMeta(rsFeatures.fileExt))>
				</cfif>
				</cfsilent>
				<dl<cfif class neq ''> class="#class#"</cfif>>
				<cfif menutype eq  "calendar_features" and isDate(rsFeatures.displaystart)>
					<dt class="releaseDate"><cfif LSDateFormat(rsFeatures.displaystart,"short") lt LSDateFormat(rsFeatures.displaystop,"short")>#LSDateFormat(rsFeatures.displaystart,getShortDateFormat())# - #LSDateFormat(rsFeatures.displaystop,getShortDateFormat())#<cfelse>#LSDateFormat(rsFeatures.displaystart,getLongDateFormat())#</cfif></dt>
				<cfelseif LSisDate(rsFeatures.releasedate)>
					<dt class="releaseDate">#LSDateFormat(rsFeatures.releasedate,getLongDateFormat())#</dt>
				</cfif>
					<dt><a href="#theLink#">#rsFeatures.MenuTitle#</a></dt>
				<cfif hasImage>
					<dd class="image">
						<!---<a href="#application.configBean.getContext()#/tasks/render/file/index.cfm?fileID=#rsFeatures.FileID#&ext=.#rsFeatures.fileExt#" title="#HTMLEditFormat(rsFeatures.title)#" rel="shadowbox[#cssID#]">---><img src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileid=#rsFeatures.fileid#" alt="#htmlEditFormat(rsFeatures.title)#"/><!---</a>--->
					</dd>
				</cfif>
				<cfif hasSummary and len(rsFeatures.summary)>
					<dd>#rsFeatures.summary#
						<span class="readMore">#addlink(rsFeatures.type,rsFeatures.filename,rbFactory.getKey('list.readmore'),rsFeatures.target,rsFeatures.targetParams,rsFeatures.contentid,request.siteid,'',application.configBean.getContext(),application.configBean.getStub(),application.configBean.getIndexFile())#</span>
					</dd>
				</cfif>
				<cfif len(rsFeatures.credits)>
					<dd class="credits">#rbFactory.getKey('list.by')# #rsFeatures.credits#</dd>
				</cfif>
				<cfif doMeta and hasComments>
					<dd class="comments"><cfif isNumeric(rsFeatures.comments)>#rsFeatures.comments#<cfelse>0</cfif> <cfif rsFeatures.comments neq 1>#rbFactory.getKey('list.comments')#<cfelse>#rbFactory.getKey('list.comment')#</cfif></dd>
				</cfif>
				<cfif len(rsFeatures.tags)>
					<dd class="tags"><cfmodule template="nav/dsp_tag_line.cfm" tags="#rsFeatures.tags#"></dd>
				</cfif>
				<cfif doMeta and hasRatings>
					<dd class="ratings">#rbFactory.getKey('list.rating')#: <img class="ratestars" src="#application.configBean.getContext()#/#application.settingsmanager.getSite(request.siteid).getDisplayPoolID()#/includes/display_objects/rater/images/star_#application.raterManager.getStarText(rsFeatures.rating)#.png" alt="<cfif isNumeric(rsFeatures.rating)>#rsFeatures.rating# star<cfif rsFeatures.rating gt 1>s</cfif></cfif>" border="0"></dd>
				</cfif>
				</dl>
	</cfloop>
		<dl class="moreResults">
		<dt>&raquo; <a href="#application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(request.siteid,rssection.filename)#?categoryid=#categoryBean.getCategoryID()#">#rbFactory.getKey('list.viewall')#<!--- #rsSection.menutitle# ---></a></dt></dl>
</div>
<cfelse>
	<!-- Empty or Inactive Section Features '#rsSection.MenuTitle# - #categoryBean.getName()#' -->
</cfif>
</cfoutput>

