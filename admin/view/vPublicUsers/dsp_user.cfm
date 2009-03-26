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
<cfparam name="attributes.activeTab" default="0" />
<cfset rsSubTypes=application.classExtensionManager.getSubTypesByType(2,attributes.siteID) />
<cfquery name="rsNonDefault" dbtype="query">
select * from rsSubTypes where subType <> 'Default'
</cfquery>

<cfoutput><form action="index.cfm?fuseaction=cPublicUsers.update&userid=#attributes.userid#&routeid=#attributes.routeid#&siteid=#attributes.siteid#" method="post" enctype="multipart/form-data" name="form1" onsubmit="return validate(this);"  autocomplete="off" >
	<h2>#application.rbFactory.getKeyValue(session.rb,'user.memberform')#</h2>
	
	#application.utility.displayErrors(request.userBean.getErrors())#
	
	<p>#application.rbFactory.getKeyValue(session.rb,'user.requiredtext')#</p>
	
	<div id="page_tabView">
<div class="page_aTab">
	<dl class="oneColumn">
		<cfif rsNonDefault.recordcount>
		<dt class="first">#application.rbFactory.getKeyValue(session.rb,'user.type')#</dt>
		<dd><select name="subtype" class="dropdown" onchange="resetExtendedAttributes('#request.userBean.getUserID()#','2',this.value,'#application.settingsManager.getSite(attributes.siteID).getPublicUserPoolID()#');">
			<option value="Default" <cfif  request.userBean.getSubType() eq "Default">selected</cfif>> #application.rbFactory.getKeyValue(session.rb,'user.default')#</option>
				<cfloop query="rsNonDefault">
					<option value="#rsNonDefault.subtype#" <cfif request.userBean.getSubType() eq rsNonDefault.subtype>selected</cfif>>#rsNonDefault.subtype#</option>
				</cfloop>
			</select>
		</dd>
		<cfelse>
			<input type="hidden" name="subtype" value="Default"/>
		</cfif>
		
		<dt <cfif not  rsNonDefault.recordcount>class="first"</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.fname')#*</dt> 
		<dd><input id="fname" name="fname" type="text" value="#HTMLEditFormat(request.userBean.getfname())#"  required="true" message="#application.rbFactory.getKeyValue(session.rb,'user.fnamerequired')#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.lname')#*</dt>
		<dd><input id="lname" name="lname" type="text" value="#HTMLEditFormat(request.userBean.getlname())#"  required="true" message="The 'Last Name' form field is required" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.company')#</dt>
		<dd><input id="organization" name="company" type="text" value="#HTMLEditFormat(request.userBean.getcompany())#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.jobtitle')#</dt>
		<dd><input id="jobtitle" name="jobtitle" type="text" value="#HTMLEditFormat(request.userBean.getjobtitle())#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.mobilephone')#</dt>
		<dd><input id="mobilePhone" name="mobilePhone" type="text" value="#HTMLEditFormat(request.userBean.getMobilePhone())#" class="text"></dd> 
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.email')#*</dt>
		<dd><input id="email" name="email" type="text" value="#HTMLEditFormat(request.userBean.getemail())#" class="text" required="true" validate="email" message="#application.rbFactory.getKeyValue(session.rb,'user.emailvalidate')#"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.username')#*</dt>
		<dd><input id="username"  name="usernameNoCache" type="text" value="#HTMLEditFormat(request.userBean.getusername())#" class="text" required="true" message="The 'Username' field is required" autocomplete="off"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.newpassword')#**</dt>
<dd><input name="passwordNoCache" autocomplete="off" validate="match" matchfield="password2" type="password" value="" class="text"  message="#application.rbFactory.getKeyValue(session.rb,'user.passwordmatchvalidate')#"></dd> 
<dt>#application.rbFactory.getKeyValue(session.rb,'user.newpasswordconfirm')#**</dt>
<dd><input  name="password2" autocomplete="off" type="password" value="" class="text"  message="#application.rbFactory.getKeyValue(session.rb,'user.passwordconfirmvalidate')#"></dd>    
		
</dl>		
</div>
	<div class="page_aTab">
		<cfsilent>
		<cfparam name="attributes.address1" default=""/>
		<cfparam name="attributes.address2" default=""/>
		<cfparam name="attributes.city" default=""/>
		<cfparam name="attributes.state" default=""/>
		<cfparam name="attributes.zip" default=""/>
		<cfparam name="attributes.country" default=""/>
		<cfparam name="attributes.phone" default=""/>
		<cfparam name="attributes.fax" default=""/>
		<cfparam name="attributes.addressURL" default=""/>
		<cfparam name="attributes.addressEmail" default=""/>
		<cfparam name="attributes.hours" default=""/>
		</cfsilent>
		<dl class="oneColumn">
		<cfif attributes.userid eq ''>
		<dt class="first"></dt>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.address1')#</dt>
		<dd><input id="address1" name="address1" type="text" value="#HTMLEditFormat(attributes.address1)#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.address2')#</dt>
		<dd><input id="address2" name="address2" type="text" value="#HTMLEditFormat(attributes.address2)#"  class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.city')#</dt>
		<dd><input id="city" name="city" type="text" value="#HTMLEditFormat(attributes.city)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.state')#</dt>
		<dd><input id="state" name="state" type="text" value="#HTMLEditFormat(attributes.state)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.zip')#</dt>
		<dd><input id="zip" name="zip" type="text" value="#HTMLEditFormat(attributes.zip)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.moreresults')#</dt>
		<dd><input id="country" name="country" type="text" value="#HTMLEditFormat(attributes.country)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.phone')#</dt>
		<dd><input id="phone" name="phone" type="text" value="#HTMLEditFormat(attributes.phone)#" class="text"></dd>	
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.fax')#</dt>
		<dd><input id="fax" name="fax" type="text" value="#HTMLEditFormat(attributes.fax)#" class="text"></dd> 
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.website')# (#application.rbFactory.getKeyValue(session.rb,'user.includehttp')#)</dt>
		<dd><input id="addressURL" name="addressURL" type="text" value="#HTMLEditFormat(attributes.addressURL)#" class="text"></dd> 
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.email')#</dt>
		<dd><input id="addressEmail" name="addressEmail" validate="email" message="The 'Email' field must be in a valid email format" type="text" value="#HTMLEditFormat(attributes.addressEmail)#" class="text"></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.hours')#</dt>
		<dd><textarea id="hours" name="hours" >#HTMLEditFormat(attributes.hours)#</textarea></dd>   
		<input type="hidden" name="isPrimary" value="1" />
		<cfelse>
		<dt class="first"><ul id="navTask"><li><a href="index.cfm?fuseaction=cPublicUsers.editAddress&userID=#attributes.userid#&siteid=#attributes.siteid#&routeID=#attributes.routeid#&addressID=">#application.rbFactory.getKeyValue(session.rb,'user.addnewaddress')#</a></li></ul></dt>
		<cfset rsAddresses=request.userBean.getAddresses()>
		<dd>
		<cfif rsAddresses.recordcount>
		<table id="metadata">
		<tr><th>#application.rbFactory.getKeyValue(session.rb,'user.primary')#</th><th>#application.rbFactory.getKeyValue(session.rb,'user.address')#</th><th class="adminstration"></th></tr>
		<cfloop query="rsAddresses">
		<tr>
			<td>
			<input type="radio" name="primaryAddressID" value="#rsAddresses.addressID#" <cfif rsAddresses.isPrimary eq 1 or rsAddresses.recordcount eq 1>checked</cfif>>
			</td>
			<td>
			<cfif rsAddresses.addressName neq ''><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPublicUsers.editAddress&userID=#attributes.userid#&siteid=#attributes.siteid#&routeID=#attributes.routeid#&addressID=#rsAddresses.addressID#"><strong>#rsAddresses.addressName#</strong></a><br/></cfif>
			<cfif rsAddresses.address1 neq ''>#rsAddresses.address1#<br/></cfif>
			<cfif rsAddresses.address2 neq ''>#rsAddresses.address2#<br/></cfif>
			<cfif rsAddresses.city neq ''>#rsAddresses.city# </cfif><cfif rsAddresses.state neq ''><cfif rsaddresses.city neq ''>,</cfif> #rsAddresses.state# </cfif><cfif rsaddresses.zip neq ''> #rsAddresses.zip#</cfif><cfif rsAddresses.city neq '' or rsAddresses.state neq '' or rsAddresses.zip neq ''><br/></cfif>
			<cfif rsAddresses.phone neq ''>#application.rbFactory.getKeyValue(session.rb,'user.phone')#: #rsAddresses.phone#<br/></cfif>
			<cfif rsAddresses.fax neq ''>#application.rbFactory.getKeyValue(session.rb,'user.fax')#: #rsAddresses.fax#<br/></cfif>
			<cfif rsAddresses.addressURL neq ''>#application.rbFactory.getKeyValue(session.rb,'user.website')#: <a href="#rsAddresses.addressURL#" target="_blank">#rsAddresses.addressURL#</a><br/></cfif>
			<cfif rsAddresses.addressEmail neq ''>#application.rbFactory.getKeyValue(session.rb,'user.email')#: <a href="mailto:#rsAddresses.addressEmail#">#rsAddresses.addressEmail#</a></cfif>
			</td>
			<td nowrap class="administration"><ul class="users"><li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,'user.edit')#" href="index.cfm?fuseaction=cPublicUsers.editAddress&userID=#attributes.userid#&siteid=#attributes.siteid#&routeID=#attributes.routeid#&addressID=#rsAddresses.addressID#">[#application.rbFactory.getKeyValue(session.rb,'user.moreresults')#]</a></li>
			<cfif rsAddresses.isPrimary neq 1><li class="delete"><a title="Delete" href="index.cfm?fuseaction=cPublicUsers.updateAddress&userID=#attributes.userid#&action=delete&siteid=#attributes.siteid#&routeID=#attributes.routeid#&addressID=#rsAddresses.addressID#" onclick="return confirm('#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteaddressconfirm'))#');">[#application.rbFactory.getKeyValue(session.rb,'user.delete')#]</a></li><cfelse><li class="deleteOff">#application.rbFactory.getKeyValue(session.rb,'user.delete')#</li></cfif></ul></td>
		</tr>
		</cfloop>
		</table>
		<cfelse>
		<em>#application.rbFactory.getKeyValue(session.rb,'user.noaddressinformation')#</em>
		</cfif>
		</dd>
		</cfif>
		</dl>
	</div>
	<div class="page_aTab">
		<dl class="oneColumn">
		<cfif request.rsPublicGroups.recordcount>
		<dt class="first">#application.rbFactory.getKeyValue(session.rb,'user.groups')#</dt>
		<dd>
		<ul><cfloop query="request.rspublicgroups">
		<li><input name="GroupID" type="checkbox" class="checkbox" value="#request.rspublicgroups.UserID#" <cfif listfind(request.userBean.getgroupid(),request.rspublicgroups.UserID) or listfind(attributes.groupid,request.rsPublicGroups.UserID)>checked</cfif>> #request.rsPublicGroups.site# - #request.rspublicgroups.groupname#</li>
		</cfloop>
		</ul>
		</dd>
		<cfelse>
		<dd><br/><em>#application.rbFactory.getKeyValue(session.rb,'user.nogroups')#</em></dd>
		</cfif>
		</dl>
	</div>	
	<div class="page_aTab">
		<dl class="oneColumn">
		<dd class="first">
			<cfif application.categoryManager.getCategoryCount(attributes.siteid)>
			<ul class="interestGroups">
				<cfloop collection="#application.settingsManager.getSites()#" item="site">
					<cfif application.settingsManager.getSite(site).getPrivateUserPoolID() eq attributes.siteid>
						<li>
							<cfoutput>#application.settingsManager.getSite(site).getSite()#</cfoutput>
							<cf_dsp_categories_nest siteID="#attributes.siteID#" parentID="" categoryID="#attributes.categoryID#" nestLevel="0" >
						</li>
					</cfif>
				</cfloop>
			</ul>
			<cfelse>
			<em>#application.rbFactory.getKeyValue(session.rb,'user.nointerestcategories')#</em>
			</cfif> 
		</dd>
		
	</dl>
	</div>
	 <cfif rsSubTypes.recordcount>
		<div class="page_aTab">
			<span id="extendSets"></span>
			<script type="text/javascript">
			loadExtendedAttributes('#request.userbean.getUserID()#','#request.userbean.getType()#','#request.userBean.getSubType()#','#application.settingsManager.getSite(attributes.siteID).getPublicUserPoolID()#');
			</script>	
	</div>
	<cfhtmlhead text='<script type="text/javascript" src="js/user.js"></script>'>
	</cfif>
	<div class="page_aTab">
		<dl class="oneColumn">
		<dt class="first">#application.rbFactory.getKeyValue(session.rb,'user.emailbroadcaster')#</dt>
		<dd><ul class="radioGroup"><li><input name="subscribe" type="radio" class="radio" value="1"<cfif request.userBean.getsubscribe() eq 1>Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.yes')#</li><li><input name="subscribe" type="radio" class="radio" value="0"<cfif request.userBean.getsubscribe() eq 0>Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.no')#</li></ul></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.inactive')#</dt>
		<dd><ul class="radioGroup">
			
			<cfif application.settingsManager.getSite(attributes.siteid).getAccountActivationScript() neq '' and attributes.userID neq '' and request.userBean.getInActive() eq 1>
			<li><input name="InActive" onclick="$('activationNofityLI').style.display='';$('activationNotifyCB').disabled=false;$('activationNotifyCB').checked=true;" type="radio" class="radio" value="0"<cfif request.userBean.getInActive() eq 0 >Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.yes')#</li><li><input name="InActive" onclick="$('activationNofityLI').style.display='none';$('activationNotifyCB').disabled=true;$('activationNotifyCB').checked=false;" type="radio" class="radio" value="1"<cfif request.userBean.getInActive() eq 1 >Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.no')#</li>
			<li id="activationNofityLI" style="display:none;">
				<input type="checkbox"  id="activationNotifyCB" name="activationNotify" value="1" disabled/> #application.rbFactory.getKeyValue(session.rb,'user.sendactivationnotification')#
			</li>
			<cfelse>
			<li><input name="InActive" type="radio" class="radio" value="0"<cfif request.userBean.getInActive() eq 0 >Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.yes')#</li><li><input name="InActive" type="radio" class="radio" value="1"<cfif request.userBean.getInActive() eq 1 >Checked</cfif>>#application.rbFactory.getKeyValue(session.rb,'user.no')#</li>
			</cfif>
		</ul></dd>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.tags')#</dt>
		<dd><input id="tags" name="tags" type="text" value="#HTMLEditFormat(request.userBean.getTags())#" class="text"></dd> 
		<cfif isUserInRole("S2") or isUserInRole("Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0")>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.usertype')#</dt>
		<dd><ul class="radioGroup"><li><input name="switchToPrivate" type="radio" class="radio" value="1"> #application.rbFactory.getKeyValue(session.rb,'user.administrative')#</li><li><input name="switchToPrivate" type="radio" class="radio" value="0" Checked> #application.rbFactory.getKeyValue(session.rb,'user.sitemember')#</li></ul></dd>
		</cfif>
		<dt><input type="checkbox" id="contactFormBox" name="ContactForm" value="#attributes.siteid#" <cfif listfind(request.userBean.getcontactform(),attributes.siteid)>Checked</cfif>> <label for="contactFormBox">#application.rbFactory.getKeyValue(session.rb,'user.contactform')#</label></dt>
		<dt>#application.rbFactory.getKeyValue(session.rb,'user.remoteid')#</dt>
		<dd><input id="remoteID" name="remoteID" type="text" value="#HTMLEditFormat(request.userBean.getRemoteID())#"  class="text"></dd>
		</dl>
	</div>
	</div>
	
		<cfif attributes.userid eq ''>
        
				<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'add');"><span>#application.rbFactory.getKeyValue(session.rb,'user.add')#</span></a>
           <cfelse>
				<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'delete','#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.deleteuserconfirm'))#');"><span>#application.rbFactory.getKeyValue(session.rb,'user.delete')#</span></a>
            	<a class="submit" href="javascript:;" onclick="return submitForm(document.forms.form1,'update');"><span>#application.rbFactory.getKeyValue(session.rb,'user.update')#</span></a>
				
           </cfif>

		<input type="hidden" name="type" value="2">
		<input type="hidden" name="action" value="">
		<input type="hidden" name="contact" value="0">
		<input type="hidden" name="groupid" value="">
		<input type="hidden" name="ContactForm" value="">
		<input type="hidden" name="isPublic" value="1">

<cfhtmlhead text='<link rel="stylesheet" href="css/tab-view.css" type="text/css" media="screen">'>
<cfhtmlhead text='<script type="text/javascript" src="js/tab-view.js"></script>'>

<script type="text/javascript">
initTabs(Array("#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.basic'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.addressinformation'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.groupmemberships'))#","#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.interests'))#"<cfif rsSubTypes.recordcount>,"#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.extendedattributes'))#"</cfif>,"#jsStringFormat(application.rbFactory.getKeyValue(session.rb,'user.advanced'))#"),#attributes.activeTab#,0,0);
</script>	

	</cfoutput>

</form>