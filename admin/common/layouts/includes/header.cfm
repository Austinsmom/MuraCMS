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

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfsilent>
<cfparam name="rc.originalmuraAction" default="">
<cfparam name="rc.originalcircuit" default="">
<cfparam name="rc.moduleid" default="">
<cfif not isDefined("session.mura.memberships")>
  <cflocation url="#application.configBean.getContext()#/admin/?muraAction=cLogin.logout" addtoken="false">
</cfif>
</cfsilent>

<cfoutput>
<header>
	<div class="navbar navbar-fixed-top">
	  <div class="navbar-inner">
	   <div class="container">
	      <a class="brand" href="http://www.getmura.com" title="Mura CMS"><img src="#application.configBean.getContext()#/admin/assets/images/mura_logo.png"></a>
	      <!---<a class="brand-credit" title="Blue River" target="_blank" href="http://www.blueriver.com"></a>--->
	      
	      <cfif listFind(session.mura.memberships,'S2IsPrivate')>
	       <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	          </a>
	         
	       <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-site-select">
	            <span class="icon-globe"></span>
	          </a>
	              
              <cfif application.configBean.getDashboard()>
                  <cfset baseURL="index.cfm?muraAction=cDashboard.main">
              <cfelse>
                   <cfset baseURL="index.cfm?muraAction=cArch.list&amp;moduleID=00000000000000000000000000000000000&amp;topID=00000000000000000000000000000000001">
               </cfif>
	          
	          <!--- Site Selection --->
	         <div class="nav-collapse nav-site-select">
	            <!---<ul class="nav">
		          <li class="dropdown">
		         	Current Site: 
		            <a class="dropdown-toggle" data-toggle="dropdown">
		              <i class="icon-globe"></i> #application.settingsManager.getSite(session.siteid).getSite()#
		              <b class="caret"></b>
		            </a>
		            
		            <cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
		            <ul class="dropdown-menu">
		              <cfloop query="theSiteList">
		                <li<cfif session.siteID eq theSiteList.siteID> class="active"</cfif>>
		                  <a href="#baseURL#&amp;siteID=#theSiteList.siteID#">#HTMLEditFormat(theSiteList.site)#</a>
		                </li>
		              </cfloop>
		            </ul>
		          </li>
	          </ul>--->             	 	
	             	 	
	             	 	<!--- <form novalidate="novalidate" id="siteSelect" name="siteSelect" method="get" action="#application.configBean.getContext()#/admin/">
	             	 	 	<cfif application.configBean.getDashboard()>
	             	 		<input type="hidden" name="muraAction" value="cDashboard.main">
	             	 		<cfelse>
	             	 		<input type="hidden" name="muraAction" value="cArch.list">
	             	 		<input type="hidden" name="moduleID" value="00000000000000000000000000000000000">
	             	 		<input type="hidden" name="topID" value="00000000000000000000000000000000001">
	             	 		</cfif>
	             	 		<!---<label>---><!---<i class="icon-globe"></i>---><!--- Current Site:</label>--->
	             	 	  <select name="siteid" onchange="if(this.value != ''){document.forms.siteSelect.submit();}">
	             	 			<!---<option vaue="">#application.rbFactory.getKeyValue(session.rb,"layout.selectsite")#</option>--->
	             	 		    <cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
	             	 		  	<cfloop query="theSiteList">
	             	 			<option value="#theSiteList.siteid#">#theSiteList.site#</option>
	             	 			</cfloop>
	             	 	  </select>
	             	 	</form> --->	             	 	          
	          </div>
	         
	          <div class="nav-collapse">
	            <ul class="nav pull-right">
	              
	              <!--- Global Settings --->	
	               <cfif listFind(session.mura.memberships,'S2')>
	              <!---<li class="nav-site-select">
	               	<form novalidate="novalidate" id="siteSelect" name="siteSelect" method="get" action="#application.configBean.getContext()#/admin/">
	               	 	<cfif application.configBean.getDashboard()>
		               		<input type="hidden" name="muraAction" value="cDashboard.main">
		               		<cfelse>
		               		<input type="hidden" name="muraAction" value="cArch.list">
		               		<input type="hidden" name="moduleID" value="00000000000000000000000000000000000">
		               		<input type="hidden" name="topID" value="00000000000000000000000000000000001">
	               		</cfif>
	               	  <select name="siteid" onchange="if(this.value != ''){document.forms.siteSelect.submit();}">
	               			<option vaue="">#application.rbFactory.getKeyValue(session.rb,"layout.selectsite")#</option>
	               		    <cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
	               		  	<cfloop query="theSiteList">
	               			<option value="#theSiteList.siteid#">#theSiteList.site#</option>
	               			</cfloop>
	               	  </select>
	               	</form>
	               	
	                 <!--<a class="dropdown-toggle" data-toggle="dropdown">
	                   <i class="icon-globe"></i> #application.settingsManager.getSite(session.siteid).getSite()#
	                   <b class="caret"></b>
	                 </a>
	                 
	                 <cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
	                 <ul class="dropdown-menu">
	                   <cfloop query="theSiteList">
	                     <li<cfif session.siteID eq theSiteList.siteID> class="active"</cfif>>
	                       <a href="#baseURL#&amp;siteID=#theSiteList.siteID#">#HTMLEditFormat(theSiteList.site)#</a>
	                     </li>
	                   </cfloop>
	                 </ul>-->
	               </li>--->
	               
	                  <li id="navSiteSettings" class="dropdown">
	                    <a class="dropdown-toggle" data-toggle="dropdown"><i class="icon-cogs"></i> #application.rbFactory.getKeyValue(session.rb,"layout.settings")#
	                      <b class="caret"></b>
	                    </a>
		                    <ul class="dropdown-menu">
		                    <li>
		                        <a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.list"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.globalsettings")#</a>
		                    </li>
		                    <!---<li>
		                      <a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.editSite&siteid=#session.siteid#">#application.rbFactory.getKeyValue(session.rb,"layout.editcurrentsite")#</a>
		                    </li>--->
		                    <li>
		                      <a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.editSite&siteid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.addsite")#</a>
		                    </li>
		                    <li><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.sitecopyselect"><i class="icon-copy"></i> #application.rbFactory.getKeyValue(session.rb,"layout.sitecopytool")#</a>
		                    </li>
		                    <cfif listFind(session.mura.memberships,'S2')>
		                     	<li><a href="#application.configBean.getContext()#/admin/index.cfm?#urlEncodedFormat(application.appreloadkey)#&reload=#urlEncodedFormat(application.appreloadkey)#"><i class="icon-refresh"></i> #application.rbFactory.getKeyValue(session.rb,"layout.reloadapplication")#</a></li>
		                     </cfif>
		                    </ul>
	                  </li>
	                </cfif>
	                 
	                <li id="navHelp" class="dropdown">
	                  <a class="dropdown-toggle" data-toggle="dropdown" href="http://www.getmura.com/index.cfm/support/"><i class="icon-question-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.help")#
	                   <b class="caret"></b>
	                  </a>
	                  <ul class="dropdown-menu">
	                    <li><a id="navHelpDocs" href="http://www.getmura.com/support/" target="_blank"><i class="icon-info-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.support")#</a></li>
	                	<li>
	                    <a id="navFckEditorDocs" href="http://docs.cksource.com/" target="_blank"><i class="icon-bookmark"></i> #application.rbFactory.getKeyValue(session.rb,"layout.editordocumentation")#</a></li>
	                <li><a id="navProg-API" href="http://www.getmura.com/mura/5/components/" target="_blank"><i class="icon-bookmark"></i> Component API</a></li>
	                <li><a id="navCSS-API" href="http://docs.getmura.com/index.cfm/developer-guides/" target="_blank"><i class="icon-bookmark"></i> #application.rbFactory.getKeyValue(session.rb,"layout.developers")#</a></li>
	                   <li class="last"><a id="navHelpForums" href="http://www.getmura.com/forum/" target="_blank"><i class="icon-bullhorn"></i> #application.rbFactory.getKeyValue(session.rb,"layout.supportforum")#</a></li>
	                  </ul>
	                </li> 
	                
	                <cfif session.siteid neq '' and listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
	                 <li id="navEditProfile" class="dropdown">
	                 	<a class="dropdown-toggle" data-toggle="dropdown"><i class="icon-user"></i> #HTMLEditFormat("#session.mura.fname# #session.mura.lname#")#
	                 		<b class="caret"></b></a>
		                 <ul class="dropdown-menu">
		                 <li>
		                 <a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cEditProfile.edit"><i class="icon-pencil"></i> #application.rbFactory.getKeyValue(session.rb,"layout.editprofile")#</a></li>
		                 <li id="navLogout"><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cLogin.logout"><i class="icon-signout"></i> #application.rbFactory.getKeyValue(session.rb,"layout.logout")#</a></li>
		                 </ul>
	                 </li>
	                </cfif>
	              </ul>
	          </div><!--/.nav-collapse -->
	     
	    </div>
	    </cfif>
	   </div>
	  </div>
	</div>
	
	 <cfif rc.originalcircuit neq 'cLogin'>
	 
	 <div class="subnavbar">
	 
	 	<div class="subnavbar-inner">
	 	
	 		<div class="container">
	 
	 			<ul class="mainnav">
	 				
	 				<li id="select-site" class="dropdown">
	 					
		 				  <a id="select-site-btn" href="http://#application.settingsManager.getSite(session.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.configBean.getStub()#/<cfif application.configBean.getSiteIDInURLS()>#session.siteid#/</cfif> target="_blank"><!---<i class="icon-globe"></i> --->Current Site</a>
		 				<a class="dropdown-toggle" data-toggle="dropdown">
		 				  <cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
		 				<!---<i class="icon-globe"></i>---><i></i>				<span>#application.settingsManager.getSite(session.siteid).getSite()#</span>
		 				<b class="caret"></b>
		 				</a>
	 				
	 				<ul class="dropdown-menu">
	 				    <cfloop query="theSiteList">
	 				      <li<cfif session.siteID eq theSiteList.siteID> class="active"</cfif>>
	 				        <a href="#baseURL#&amp;siteID=#theSiteList.siteID#"><i class="icon-globe"></i> #HTMLEditFormat(theSiteList.site)#</a>
	 				      </li>
	 				    </cfloop>
	 				</ul>
	 				
	 				</li>
	 				
	 				<cfif application.configBean.getDashboard()>
	 				<li<cfif  rc.originalcircuit eq 'cDashboard'> class="active"</cfif>>
	 					<a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cDashboard.main&siteid=#session.siteid#&span=#session.dashboardSpan#"> <i class="icon-dashboard"></i><span>#application.rbFactory.getKeyValue(session.rb,"layout.dashboard")#</span></a>
	 				</li>
	 				</cfif>
	 				
	 				<li <cfif  rc.originalcircuit eq 'cArch'> class="active"</cfif>>
	 					<a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cArch.list&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000">
	 						<i class="icon-list-alt"></i> <span>#application.rbFactory.getKeyValue(session.rb,"layout.sitemanager")#</span>
	 					</a>	    				
	 				</li>
	 				
	 				<cfset hidelist="cLogin">
	 				<cfif not listfindNoCase(hidelist,rc.originalcircuit)>
	 				  <cfinclude template="dsp_module_menu.cfm">
	 				</cfif>
	 				
	 				<li class="dropdown<cfif  rc.originalcircuit eq 'cPrivateusers'> active</cfif>">
	 					<a class="dropdown-toggle" data-toggle="dropdown">
	 						<i class="icon-group"></i> <span>#application.rbFactory.getKeyValue(session.rb,"layout.users")#</span>
	 						<b class="caret"></b>
	 					</a>
	 					
	 					<ul class="dropdown-menu">
	 					<li><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPrivateUsers.list&siteid=#session.siteid#"><i class="icon-group"></i> #application.rbFactory.getKeyValue(session.rb,"layout.viewadministrativeusers")#</a></li>
	 					  <li><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPrivateUsers.edituser&siteid=#session.siteid#&userid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.addadministrativeuser")#</a></li>
	 					  <li class="last"><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPrivateUsers.editgroup&siteid=#session.siteid#&userid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,"layout.addgroup")#</a></li>
	 					  <li class="divider"></li>
	 					  <cfif application.settingsManager.getSite(session.siteid).getextranet() and  application.permUtility.getModulePerm("00000000000000000000000000000000008","#session.siteid#")>
	 					    <li <cfif rc.originalcircuit eq 'cPublicUsers' or (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000008')>class="active"</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPublicUsers.list&siteid=#session.siteid#"><i class="icon-group"></i> #application.rbFactory.getKeyValue(session.rb,"user.viewsitemembers")#</a>
	 					    </li>
	 					  </cfif>
	 					  <li><a href="index.cfm?muraAction=cPublicUsers.edituser&siteid=#URLEncodedFormat(rc.siteid)#&userid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,'user.addmember')#</a></li>
	 					  <li><a href="index.cfm?muraAction=cPublicUsers.editgroup&siteid=#URLEncodedFormat(rc.siteid)#&userid="><i class="icon-plus-sign"></i> #application.rbFactory.getKeyValue(session.rb,'user.addgroup')#</a></li>
	 					  
	 					  </ul>			
	 				</li>
	 				 				
	 				<li class="dropdown<cfif  rc.originalcircuit eq 'cSettings'> active</cfif>">					
	 					<a class="dropdown-toggle" data-toggle="dropdown">
	 						<i class="icon-wrench"></i> <span>#application.rbFactory.getKeyValue(session.rb,"layout.sitesettings")#</span>
	 					<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
	 					<b class="caret"></b>
	 					</cfif>
	 					</a>
	 				
	 					
		 				<ul class="dropdown-menu">
		 					   <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(session.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')><li <cfif (rc.originalcircuit eq 'cPerm' and  rc.moduleid eq '00000000000000000000000000000000000')>class='active'</cfif>><a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cPerm.module&contentid=00000000000000000000000000000000000&siteid=#session.siteid#&moduleid=00000000000000000000000000000000000"><i class="icon-cog"></i> #application.rbFactory.getKeyValue(session.rb,"layout.permissions")#</a></li>
	 					</cfif>
	 					
	 					<li>
	 					<a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.editSite&siteid=#session.siteid#"><i class="icon-pencil"></i> #application.rbFactory.getKeyValue(session.rb,"layout.editcurrentsite")#</a></li>
	 					
		 				</ul>	
	 			 									
	 				</li>
	 			
	 			</ul>
	 			
	 			<!---<div id="select-site" class="btn-group">
	 			  <button class="btn"><i class="icon-globe"></i> #application.settingsManager.getSite(session.siteid).getSite()#</button>
	 			  <button class="btn dropdown-toggle" data-toggle="dropdown">
	 			    <span class="caret"></span>
	 			  </button>
	 			  <ul class="dropdown-menu">
	 			    <cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
	 			      <cfloop query="theSiteList">
	 			        <li<cfif session.siteID eq theSiteList.siteID> class="active"</cfif>>
	 			          <a href="#baseURL#&amp;siteID=#theSiteList.siteID#">#HTMLEditFormat(theSiteList.site)#</a>
	 			        </li>
	 			      </cfloop>
	 			  </ul>
	 			</div>--->
	 			
	 			<!---<div id="select-site" class="btn-group">
	 			  <a class="btn dropdown-toggle" data-toggle="dropdown">
	 			    <i class="icon-globe"></i> #application.settingsManager.getSite(session.siteid).getSite()#
	 			    <span class="caret"></span>
	 			  </a>
	 			  <ul class="dropdown-menu">
	 			    <cfset theSiteList=application.settingsManager.getUserSites(session.siteArray,listFind(session.mura.memberships,'S2')) />
	 			      <cfloop query="theSiteList">
	 			        <li<cfif session.siteID eq theSiteList.siteID> class="active"</cfif>>
	 			          <a href="#baseURL#&amp;siteID=#theSiteList.siteID#">#HTMLEditFormat(theSiteList.site)#</a>
	 			        </li>
	 			      </cfloop>
	 			  </ul>
	 			</div>--->
	 
	 		</div> <!-- /container -->
	 	
	 	</div> <!-- /subnavbar-inner -->
	 
	 </div> <!-- /subnavbar -->
	        	
	 <!---<div id="current-site">
	 	<div class="container">
	 		<i class="icon-globe"></i> <strong>Current Site:</strong> Site Name
	 	</div>
	 </div>--->
	        	<!---<cfinclude template="dsp_secondary_menu.cfm">--->
	  </cfif>
</header>
</cfoutput>