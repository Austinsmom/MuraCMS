<cfoutput>
<cfif attributes.type neq 'File'>
<dt>
<cfelse>
<dt class="separate">	
</cfif>	
<cfif attributes.ptype eq 'Gallery' or attributes.type neq 'File'><a href="##" class="tooltip">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectimage')#<span>#application.rbFactory.getKeyValue(session.rb,'tooltip.selectimage')#</span></a><cfelse>
#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectfile')#
</cfif>	
</dt>
<dd><input type="file" id="file" name="NewFile" class="text" <cfif attributes.ptype eq 'Gallery' or attributes.type neq 'File'>accept="image/jpeg" validate="regex" regex="(.+)(\.)(png|PNG|JPG|jpg|jpeg|JPEG)" message="#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.newimagevalidate')#"</cfif>></dd>
<cfif request.contentBean.getcontentType() eq 'image' or attributes.type neq 'File'><dd>
	<cfif len(request.contentBean.getFileID())>
		<cfif attributes.type neq 'File'>
			<img id="assocImage" src="#application.configBean.getContext()#/tasks/render/small/index.cfm?fileid=#request.contentBean.getFileID()#" /><br/><input type="checkbox" name="deleteFile" value="1" id="deleteFileBox"/> <label for="deleteFileBox">#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.removeattachedfile')#</label><br/>
		<cfelse>
			<img id="assocImage" src="#application.configBean.getContext()#/tasks/render/medium/index.cfm?fileid=#request.contentBean.getFileID()#" />
		</cfif>
	</cfif>
	<cfif attributes.type neq 'File'>
		<span id="selectAssocImage">
			<input type="hidden" name="fileid" value="#htmlEditFormat(request.contentBean.getfileid())#" />
		<a href="javascript:##;" onclick="javascript: loadAssocImages('#htmlEditFormat(attributes.siteid)#','#htmlEditFormat(request.contentBean.getFileID())#','#htmlEditFormat(attributes.contentID)#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectassocimage')#]</a>
		</span>
		<span id="selectAssocImageReInit" style="display:none">
			<input type="hidden" name="fileidReInit" value="#htmlEditFormat(request.contentBean.getfileid())#" />
			<a href="javascript:##;" onclick="javascript: loadAssocImages('#htmlEditFormat(attributes.siteid)#','#htmlEditFormat(request.contentBean.getFileID())#','#htmlEditFormat(attributes.contentID)#','',1);return false;">[#application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.selectassocimage')#]</a>
		</span>
	<cfelse>
		<input type="hidden" name="fileid" value="#htmlEditFormat(request.contentBean.getFileID())#" />
	</cfif>
	</dd>
<cfelse>
<input type="hidden" name="fileid" value="#htmlEditFormat(request.contentBean.getFileID())#" />
</cfif>
</cfoutput>