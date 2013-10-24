<!---
	This file is part of Mura CMS.

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
	the preparation of a derivative work based on Mura CMS. Thus, the terms 
	and conditions of the GNU General Public License version 2 ("GPL") cover 
	the entire combined work.

	However, as a special exception, the copyright holders of Mura CMS grant 
	you permission to combine Mura CMS with programs or libraries that are 
	released under the GNU Lesser General Public License version 2.1.

	In addition, as a special exception, the copyright holders of Mura CMS 
	grant you permission to combine Mura CMS with independent software modules 
	(plugins, themes and bundles), and to distribute these plugins, themes and 
	bundles without Mura CMS under the license of your choice, provided that 
	you follow these specific guidelines: 

	Your custom code 

	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories:

		/admin/
		/tasks/
		/config/
		/requirements/mura/
		/Application.cfc
		/index.cfm
		/MuraProxy.cfc

	You may copy and distribute Mura CMS with a plug-in, theme or bundle that 
	meets the above guidelines as a combined work under the terms of GPL for 
	Mura CMS, provided that you include the source code of that other code when 
	and as the GNU GPL requires distribution of source code.

	For clarity, if you create a modified version of Mura CMS, you are not 
	obligated to grant this special exception for your modified version; it is 
	your choice whether to do so, or to make such modified version available 
	under the GNU General Public License version 2 without this exception.  You 
	may, if you choose, apply this exception to your own modified versions of 
	Mura CMS.
--->
<cfcomponent extends="mura.cfobject">

	<cffunction name="get" access="remote" output="true">
		<cfargument name="commentID">
		<cfset var $ = getBean("MuraScope").init(session.siteid)>
		<cfset var comment = $.getBean("contentManager").getCommentBean()>
		<cfset var data = comment.setCommentID(arguments.commentID).load().getAllValues()>
		<cfoutput>#createobject("component","mura.json").encode(data)#</cfoutput>
		<cfabort>
	</cffunction>

	<cffunction name="flag" access="remote" output="true">
		<cfargument name="commentID">
		<cfset var $ = getBean("MuraScope").init(session.siteid)>
		<cfset var comment = $.getBean("contentManager").getCommentBean()>
		<cfset comment.setCommentID(arguments.commentID).load().flag()>
	</cffunction>

	<cffunction name="renderCommentsPage" access="remote" output="true">
		<cfargument name="contentID">
		<cfargument name="pageNo" required="true" default="1">
		<cfargument name="nextN" required="true" default="25">
		<cfset var $ = getBean("MuraScope").init(session.siteid)>
		<cfset var content = $.getBean('content').loadBy(contentID=arguments.contentID)>
		<cfset var crumbArray = content.getCrumbArray()>
		<cfset var it = content.getCommentsIterator()>
		<cfset var isEditor=(listFind(session.mura.memberships,'S2IsPrivate;#application.settingsManager.getSite($.event('siteID')).getPrivateUserPoolID()#')
					and application.permUtility.getnodePerm(crumbArray) neq 'none')
					or listFind(session.mura.memberships,'S2')>
		<cfset var comment = "">

		<cfoutput>
			<cfloop condition="#it.hasNext()#">
				<cfset comment = it.next()>				
				<dl>
					<dt>
						<cfif len(comment.getURL())>
							<a href="#comment.getURL()#" target="_blank">#htmleditformat(comment.getName())#</a>
						<cfelse>
							#htmleditformat(comment.getName())#
						</cfif>
						<cfif isEditor and len(comment.getEmail())>
							<a class="btn btn-default" href="javascript:noSpam('#listFirst(htmlEditFormat(comment.getEmail()),'@')#','#listlast(HTMLEditFormat(comment.getEmail()),'@')#')" onfocus="this.blur();">#$.rbKey('comments.email')#</a>
						</cfif>
						<cfif isEditor>
							<cfif yesnoformat(application.configBean.getValue("editablecomments"))>
								 <a class="editcomment btn btn-default" data-id="#comment.getCommentID()#">#$.rbKey('comments.edit')#</a>
							</cfif>
							<cfif comment.getIsApproved() neq 1>
								 <a class="btn btn-default" href="./?approvedcommentid=#comment.getCommentID()#&amp;nocache=1&amp;linkServID=#content.getContentID()#" onClick="return confirm('Approve Comment?');">#$.rbKey('comments.approve')#</a>
							</cfif>
							 <a class="btn btn-default" href="./?deletecommentid=#comment.getCommentID()#&amp;nocache=1&amp;linkServID=#content.getContentID()#" onClick="return confirm('Delete Comment?');">#$.rbKey('comments.delete')#</a>
							 <a class="btn btn-default" href="./?spamcommentid=#comment.getCommentID()#&amp;nocache=1&amp;linkServID=#content.getContentID()#" onClick="return confirm('Mark Comment As Spam?');">Spam</a>		
						</cfif>
					</dt>
					<cfif len($.currentUser().getPhotoFileID())>
						<dd class="gravatar"><img src="#$.createHREFForImage($.currentUser().getSiteID(),$.currentUser().getPhotoFileID(),'jpg', 'medium')#"></dd>
					<cfelse>
						<dd class="gravatar"><img src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(comment.getEmail())))#" /></dd>
					</cfif>
					<dd class="comment">
						#$.setParagraphs(htmleditformat(comment.getComment()))#
					</dd>
					<dd class="dateTime">
						#LSDateFormat(comment.getEntered(),"long")#, #LSTimeFormat(comment.getEntered(),"short")#
					</dd>
					<dd class="reply"><a data-id="#comment.getCommentID()#" href="##postcomment">#$.rbKey('comments.reply')#</a></dd>
					<dd class="spam"><a data-id="#comment.getCommentID()#" class="flagAsSpam" href="##">Flag as Spam</a></dd>
					<dd id="postcomment-#comment.getCommentID()#"></dd>
				</dl>
			</cfloop>
		</cfoutput>

	</cffunction>

</cfcomponent>