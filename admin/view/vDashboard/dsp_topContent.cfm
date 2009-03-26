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
<cfhtmlhead text="#session.dateKey#">
<cfset rsList=application.dashboardManager.getTopContent(attributes.siteID,attributes.limit,attributes.membersOnly,attributes.visitorStatus,attributes.startDate,attributes.stopDate) />
<cfset rsTotal=application.dashboardManager.getTotalHits(attributes.siteID,attributes.membersOnly,attributes.visitorStatus,attributes.startDate,attributes.stopDate) />
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.topviewedcontent")#</h2>

<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"params.daterange")#</h3>
<form name="searchFrm" onsubmit="return validate(this);" id="advancedSearch">
<dl>
<dt>#application.rbFactory.getKeyValue(session.rb,"params.from")#</dt>
<dd>
<input type="input" name="startDate" value="#LSDateFormat(attributes.startDate,session.dateKeyFormat)#" validate="date" message="The 'From' date is required." />
<input class="calendar" type="image" src="images/icons/cal_24.png" onclick="window.open('date_picker/index.cfm?form=searchFrm&field=startDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,"params.to")#</dt>
<dd>
<input type="input" name="stopDate" value="#LSDateFormat(attributes.stopDate,session.dateKeyFormat)#" validate="date" message="The 'To' date is required." />
<input class="calendar" type="image" src="images/icons/cal_24.png" onclick="window.open('date_picker/index.cfm?form=searchFrm&field=stopDate&format=MDY','refWin','toolbar=no,location=no,directories=no,status=no,menubar=no,resizable=yes,copyhistory=no,scrollbars=no,width=190,height=220,top=250,left=250');return false;">
</dd>
<dt>#application.rbFactory.getKeyValue(session.rb,"params.numberofitems")#</dt>
<dd><select name="limit">
		<cfloop list="10,20,30,40,50,75,100" index="i">
		<option value="#i#" <cfif attributes.limit eq i>selected</cfif>>#i#</option>
		</cfloop>
	</select>
</dd>
<dd><a class="submit" href="javascript:;" onclick="return submitForm(document.forms.searchFrm);"><span>#application.rbFactory.getKeyValue(session.rb,"params.search")#</span></a></dd>
</dl>
<input type="hidden" value="#attributes.siteID#" name="siteID"/>
<input type="hidden" value="cDashboard.topContent" name="fuseaction"/>
</form>

<h3 class="alt">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.totalviews")#: <strong>#rstotal.hits#</strong></h3>
<table class="stripe">
<tr>
<th class="varWidth">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.content")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.views")#</th>
<th>#application.rbFactory.getKeyValue(session.rb,"dashboard.session.percent")#</th>
<th>&nbsp;</th>
</tr>
<cfif rslist.recordcount>
<cfloop query="rslist">
<cfsilent>
<cfset crumbdata=application.contentManager.getCrumbList(rsList.contentid, attributes.siteid)/>
</cfsilent>
<tr>
<td class="varWidth">#application.contentRenderer.dspZoom(crumbdata,rslist.fileEXT)#</td>
<td>#rsList.hits#</td>
<td>#decimalFormat((rsList.hits/rstotal.hits)*100)#%</td>
<td class="administration">
<ul class="one">
		<cfswitch expression="#rslist.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,rsList.filename)#','#rslist.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#</a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="javascript:preview('#rslist.filename#','#rslist.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#</a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#rslist.contentid#','#rslist.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.view")#</a></li>
		</cfcase>
		</cfswitch>	
		</ul></td>
</tr>
</cfloop>
<cfelse>
<tr>
<td class="noResults" colspan="4">#application.rbFactory.getKeyValue(session.rb,"dashboard.session.nosearchresults")#</td>
</tr>
</cfif>
</table>
</cfoutput>


