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
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(1,attributes.siteID) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>
<cfoutput>
<h2>#application.rbFactory.getKeyValue(session.rb,'user.admingroupform')#</h2>
<cfif myfusebox.originalfuseaction eq "editgroup" and attributes.userid neq ''>
<ul id="navTask"><li><a href="javascript:intuserselect('#attributes.userid#',1,<cfif isUserInRole('S2')>1<cfelse>0</cfif>,'#attributes.siteid#')">#application.rbFactory.getKeyValue(session.rb,'user.addadminusertogroup')#</a></li></ul></cfif>
</cfoutput>
    <cfswitch expression="#request.userBean.getperm()#">
	  	<cfcase value="1">
		<!--topid form system groups---><cfoutput><h3><strong>#application.rbFactory.getKeyValue(session.rb,'user.group')#:</strong> #request.userBean.getgroupname()#</h3>
		</cfoutput>
		</cfcase><cfdefaultcase>
				<!--top form non-system groups--->
<cfoutput>
#application.utility.displayErrors(request.userBean.getErrors())#

 <form action="index.cfm?fuseaction=cPrivateUsers.update&userid=#attributes.userid#" enctype="multipart/form-data" method="post" name="form1" onsubmit="return validate(this);">
<cfif rsSubTypes.recordcount>
<div id="page_tabView">
<div class="page_aTab">
</cfif>
<dl class="oneColumn">
<cfif rsNonDefault.recordcount>
		<dt class="first">#application.rbFactory.getKeyValue(session.rb,'user.type')#</dt>
		<dd><select name="subtype" class="dropdown" onchange="resetExtendedAttributes('#request.userBean.getUserID()#','1',this.value,'#application.settingsManager.getSite(attributes.siteID).getPrivateUserPoolID()#');">
			<option value="Default" <cfif  request.userBean.getSubType() eq "Default">selected</cfif>> #application.rbFactory.getKeyValue(session.rb,'user.default')#</option>
				<cfloop query="rsNonDefault">
					<option value="#rsNonDefault.subtype#" <cfif request.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>#rsNonDefault.subtype#</option>
				</cfloop>
			</select>
		</dd>
		<cfelse>
			<input type="hidden" name="subtype" value="Default"/>
		</cfif>
		
		<dt <cfif not  rsNonDefault.recordcount>class="first"</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.groupname')#</dt>
<dd><input type="text" class="text" name="groupname" value="#HTMLEditFormat(request.userBean.getgroupname())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.groupnamerequired')#"></dd>
<dt>#application.rbFactory.getKeyValue(session.rb,'user.email')#</dt>
<dd><input type="text" class="text" name="email" value="#HTMLEditFormat(request.userBean.getemail())#"></dd>

<dt>#application.rbFactory.getKeyValue(session.rb,'user.contactform')#</dt>
 <dd><ul><cfloop collection="#application.settingsManager.getSites()#" item="site">
 <cfif application.settingsManager.getSite(site).getPrivateUserPoolID() eq application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()>
 <li><input type="checkbox" name="ContactForm" value="#site#" <cfif listfind(request.userBean.getcontactform(),site)>Checked</cfif>> #application.settingsManager.getSite(site).getSite()#</li>
 </cfif></cfloop></ul></dd>
</dl>

 <cfif rsSubTypes.recordcount>
	</div>
<div id="page_tabView">
<div class="page_aTab">
<span id="extendSets"></span>	
</div>
</div>

<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>
<cfhtmlhead text='<script type="text/javascript" src="js/user.js"></script>'>
<script type="text/javascript">
loadExtendedAttributes('#request.userbean.getUserID()#','1','#request.userbean.getSubType()#','#application.settingsManager.getSite(attributes.siteID).getPrivateUserPoolID()#');	
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))#"),0,0,0);
</script>	
</cfif>


<cfif attributes.userid eq ''>
<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'user.add')#</span></a><cfelse>
					<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'user.update')#</span></a>
					<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deletegroupconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'user.delete')#</span></a></cfif><input type="hidden" name="action" value=""><input type="hidden" name="type" value="1"><input type="hidden" name="contact" value="0">
					<input type="hidden" name="isPublic" value="0">
					<input type="hidden" name="siteid" value="#attributes.siteid#"></cfoutput></form>
		</cfdefaultcase>
</cfswitch>


      <cfif attributes.userid neq ''><cfoutput><h4>#application.rbFactory.getKeyValue(session.rb,'user.groupmembers')#</h4> 
        <table class="stripe">
            <tr> 
              <th class="varWidth">#application.rbFactory.getKeyValue(session.rb,'user.name')#</th>
              <th>#application.rbFactory.getKeyValue(session.rb,'user.email')#</th>
              <th>#application.rbFactory.getKeyValue(session.rb,'user.update')#</th>
			  <th>#application.rbFactory.getKeyValue(session.rb,'user.time')#</th>
              <th>#application.rbFactory.getKeyValue(session.rb,'user.authoreditor')#</th>
              <th>&nbsp;</th>
            </tr></cfoutput>
          <cfif request.rsgrouplist.recordcount>
            <cfoutput query="request.rsgrouplist" maxrows="#request.nextN.recordsperPage#" startrow="#attributes.startrow#"> 
			  <tr> 
                <td class="varWidth"><a href="index.cfm?fuseaction=#iif(request.rsgrouplist.isPublic,de('cPublicUsers'),de('cPrivateUsers'))#.edituser&userid=#request.rsgrouplist.UserID#&routeid=#attributes.userid#&siteid=#attributes.siteid#">#lname#, #fname# <cfif company neq ''> (#company#)</cfif></a></td>
                <td><cfif request.rsgrouplist.email gt ""><a href="mailto:#request.rsgrouplist.email#">#email#</a><cfelse>&nbsp;</cfif></td>
                <td>#LSDateFormat(lastupdate,session.dateKeyFormat)#</td>
				<td>#LSTimeFormat(lastupdate,"short")#</td>
              <td>#LastUpdateBy#</td>
                <td class="administration"><ul class="group"><li class="edit"><a href="index.cfm?fuseaction=#iif(request.rsgrouplist.isPublic,de('cPublicUsers'),de('cPrivateUsers'))#.edituser&userid=#request.rsgrouplist.UserID#&routeid=#attributes.userid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'user.edit')#</a></li><li class="delete"><a href="index.cfm?fuseaction=cPrivateUsers.removefromgroup&userid=#request.rsgrouplist.UserID#&routeid=#attributes.userid#&groupid=#attributes.userid#&siteid=#attributes.siteid#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.removeconfirm'))#')">#application.rbFactory.getKeyValue(session.rb,'user.remove')#</a></li></ul></td>
              </tr>
            </cfoutput> 
		
			<cfelse>
            <tr> 
              <td class="noResults" colspan="6"><cfoutput>#application.rbFactory.getKeyValue(session.rb,'user.nogroupmembers')#</cfoutput></td>
            </tr>
          </cfif>
      </table>
     </cfif>
	
	<cfif request.nextN.numberofpages gt 1> 
		<p class="moreResults">#application.rbFactory.getKeyValue(session.rb,'user.moreresults')#: <cfoutput>
			<cfif request.nextN.currentpagenumber gt 1>
			<a href="index.cfm?fuseaction=cPrivateUsers.editgroup&startrow=#request.nextN.previous#&userid=#attributes.userid#&siteid=#attributes.siteid#">&laquo;&nbsp;#application.rbFactory.getKeyValue(session.rb,'user.prev')#</a> 
			</cfif>
			<cfloop from="#request.nextn.firstPage#"  to="#request.nextN.lastPage#" index="i"><cfif request.nextN.currentpagenumber eq i> <strong>#i#</strong> <cfelse> <a href="index.cfm?fuseaction=cPrivateUsers.editgroup&startrow=#evaluate('(#i#*#request.nextN.recordsperpage#)-#request.nextN.recordsperpage#+1')#&userid=#attributes.userid#&siteid=#attributes.siteid#">#i#</a> </cfif></cfloop>
           	<cfif request.nextN.currentpagenumber lt request.nextN.NumberOfPages>
			<a href="index.cfm?fuseaction=cPrivateUsers.editgroup&startrow=#request.nextN.next#&userid=#attributes.userid#&siteid=#attributes.siteid#">#application.rbFactory.getKeyValue(session.rb,'user.next')#&nbsp;&raquo;</a> 
			</cfif></cfoutput>
		</p>
	</cfif>