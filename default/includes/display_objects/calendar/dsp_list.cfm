<!--- This file is part of Mura CMS.

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

<cfsilent>
<cfset variables.iterator=$.getBean("contentIterator")>
<cfset variables.iterator.setQuery(variables.rsSection,$.content('nextN'))>

<cfset event.setValue("currentNextNID",$.content('contentID'))>

<cfif not len($.event("nextNID")) or $.event("nextNID") eq $.event("currentNextNID")>
	<cfif event.getContentBean().getNextN() gt 1>
		<cfset variables.currentNextNIndex=$.event("startRow")>
		<cfset variables.iterator.setStartRow(variables.currentNextNIndex)>
	<cfelse>
		<cfset variables.currentNextNIndex=$.event("pageNum")>
		<cfset variables.iterator.setPage(variables.currentNextNIndex)>
	</cfif>
<cfelse>	
	<cfset variables.currentNextNIndex=1>
	<cfset variables.iterator.setPage(1)>
</cfif>

<cfset variables.nextN=application.utility.getNextN(rsSection,event.getContentBean().getNextN(),currentNextNIndex)>

</cfsilent>

<cfif variables.iterator.getRecordcount()>
	<cfoutput>
	<div id="svPortal" class="svIndex">
		<cfsilent>
			<cfif NOT len($.content("displayList"))>
				<cfset variables.contentListFields="Title,Summary,Date,Image,Tags,Credits">
					
				<cfif application.contentGateway.getHasComments($.event('siteid'),$.content('contentID'))>
					<cfset variables.contentListFields=listAppend(contentListFields,"Comments")>
				</cfif>
				
				<cfif application.contentGateway.getHasRatings($.event('siteid'),$.content('contentID'))>
					<cfset variables.contentListFields=listAppend(contentListFields,"Rating")>
				</cfif>
				<cfset $.content("displayList",variables.contentListFields)>
			</cfif>
		</cfsilent>
		#dspObject_Include(thefile='dsp_content_list.cfm',
			fields=$.content("displayList"),
			type="Portal", 
			iterator= variables.iterator,
			imageSize=$.content("ImageSize"),
			imageHeight=$.content("ImageHeight"),
			imageWidth=$.content("ImageWidth")
			)#
		<cfif variables.nextn.numberofpages gt 1>
			#dspObject_Include(thefile='dsp_nextN.cfm')#
		</cfif>	
	</div>
	</cfoutput>
</cfif>

<cfif not variables.iterator.getRecordCount()>
     <cfoutput>
     <cfif request.filterBy eq "releaseMonth">
     <div id="svPortal">
	     <br>
	     <p>#$.rbKey('list.nocontentmonth')#</p>    
     </div>
     <cfelseif request.filterBy eq "releaseDate">
     <div id="svPortal">
	     <br>
	     <p>#$.rbKey('list.nocontentday')#</p>
     </div>
     <cfelse>
     <div id="svPortal">
         <p>#$.rbKey('list.nocontent')#</p>   
     </div>
     </cfif>
     </cfoutput>
</cfif>
