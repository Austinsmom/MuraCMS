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

<cfsilent>
<cfparam name="request.sortBy" default=""/>
<cfparam name="request.sortDirection" default=""/>
<cfparam name="request.day" default="0"/>
<cfparam name="request.pageNum" default="1"/>
<cfparam name="request.startRow" default="1"/>
<cfparam name="request.filterBy" default=""/>
<cfparam name="request.currentNextNID" default=""/>
<cfif variables.nextN.recordsPerPage gt 1>
<cfset variables.paginationKey="startRow">
<cfelse>
<cfset variables.paginationKey="pageNum">
</cfif>
<cfset variables.qrystr="" />
<cfset variables.rbFactory=getSite().getRBFactory() />
<cfif len(request.sortBy)>
	<cfset variables.qrystr="&sortBy=#request.sortBy#&sortDirection=#request.sortDirection#"/>
</cfif>
<cfif len(request.categoryID)>
	<cfset variables.variables.qrystr=variables.qrystr & "&categoryID=#request.categoryID#"/>
</cfif>
<cfif len(request.relatedID)>
	<cfset variables.qrystr=variables.qrystr & "&relatedID=#request.relatedID#"/>
</cfif>
<cfif len(request.currentNextNID)>
	<cfset variables.qrystr=variables.qrystr & "&nextNID=#request.currentNextNID#"/>
</cfif>
<cfif len(request.filterBy)>
<cfif isNumeric(request.day) and request.day>
	<cfset variables.qrystr=variables.qrystr & "&month=#request.month#&year=#request.year#&day=#request.day#&filterBy=#request.filterBy#">
</cfif>
<cfelse>
<cfif isNumeric(request.day) and request.day>
	<cfset variables.qrystr=variables.qrystr & "&month=#request.month#&year=#request.year#&day=#request.day#">
</cfif>
</cfif>
</cfsilent>
<cfoutput>
<dl class="moreResults">
	<cfif variables.nextN.recordsPerPage gt 1><dt>#variables.rbFactory.getKey('list.moreresults')#:</dt></cfif>
	<dd>
		<ul>
		<cfif variables.nextN.currentpagenumber gt 1>
		<cfif request.muraExportHtml>
			<cfif variables.nextN.currentpagenumber eq 2>
			<li class="navPrev"><a href="index.html">&laquo;&nbsp;#variables.rbFactory.getKey('list.previous')#</a></li>
			<cfelse>
			<li class="navPrev"><a href="index#evaluate('#variables.nextn.currentpagenumber#-1')#.html">&laquo;&nbsp;#variables.rbFactory.getKey('list.previous')#</a></li>
			</cfif>
		<cfelse>
			<li class="navPrev"><a href="#xmlFormat('?#paginationKey#=#variables.nextN.previous##qrystr#')#">&laquo;&nbsp;#rbFactory.getKey('list.previous')#</a></li>
		</cfif>
		</cfif>
		<cfloop from="#variables.nextN.firstPage#"  to="#variables.nextN.lastPage#" index="i">
			<cfif variables.nextn.currentpagenumber eq i>
				<li class="current">#i#</li>
			<cfelse>
				<cfif request.muraExportHtml>
					<cfif i eq 1>
					<li><a href="index.html">#i#</a></li>
					<cfelse>
					<li><a href="index#i#.html">#i#</a></li>
					</cfif>
				<cfelse>
					<li><a href="#xmlFormat('?#paginationKey#=#evaluate('(#i#*#variables.nextN.recordsperpage#)-#variables.nextN.recordsperpage#+1')##qrystr#')#">#i#</a></li>
				</cfif>
			</cfif>
		</cfloop>
		<cfif variables.nextN.currentpagenumber lt variables.nextN.NumberOfPages>
			<cfif request.muraExportHtml>
				<li class="navNext"><a href="index#evaluate('#variables.nextn.currentpagenumber#+1')#.html">#rbFactory.getKey('list.next')#&nbsp;&raquo;</a></li>
			<cfelse>
				<li class="navNext"><a href="#xmlFormat('?#paginationKey#=#variables.nextN.next##variables.qrystr#')#">#rbFactory.getKey('list.next')#&nbsp;&raquo;</a></li>
			</cfif>
		</cfif>
		</ul>
	</dd>
</dl>
</cfoutput>