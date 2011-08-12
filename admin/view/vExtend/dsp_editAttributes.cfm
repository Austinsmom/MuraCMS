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

<cfset subType=application.classExtensionManager.getSubTypeByID(attributes.subTypeID) />
<cfset extendSet=subType.loadSet(attributes.extendSetID)/>
<cfset attributesArray=extendSet.getAttributes() />
<h2>Manage Attributes Set</h2>
<cfoutput>
<ul class="metadata">
		<li><strong>Class Extension:</strong> #application.classExtensionManager.getTypeAsString(subType.getType())# / #subType.getSubType()#</li>
		<li><strong>Attributes Set:</strong> #extendSet.getName()#</li>
</ul>

<ul id="navTask">
<li><a href="index.cfm?fuseaction=cExtend.listSubTypes&siteid=#URLEncodedFormat(attributes.siteid)#">List All Class Extensions</a></li>
<li><a href="index.cfm?fuseaction=cExtend.editSubType&subTypeID=#URLEncodedFormat(attributes.subTypeID)#&siteid=#URLEncodedFormat(attributes.siteid)#">Edit Class Extension</a></li>
<li><a href="index.cfm?fuseaction=cExtend.editSet&subTypeID=#URLEncodedFormat(attributes.subTypeID)#&extendSetID=#URLEncodedFormat(attributes.extendSetID)#&siteid=#URLEncodedFormat(attributes.siteid)#">Edit Attribute Set</a></li>
<li><a href="index.cfm?fuseaction=cExtend.listSets&subTypeID=#URLEncodedFormat(attributes.subTypeID)#&siteid=#URLEncodedFormat(attributes.siteid)#">Back to Attribute Sets</a></li>
<!--- <li><a href="index.cfm?fuseaction=cExtend.editSet&subTypeID=#attributes.subTypeID#&&extendSetID=#attributes.extendSetID#&siteid=#URLEncodedFormat(attributes.siteid)#&attributeID=">Add Attribute</a></li> --->
</ul>

<cfset newAttribute=extendSet.getAttributeBean() />
<cfset newAttribute.setSiteID(attributes.siteID) />
<cfset newAttribute.setOrderno(arrayLen(attributesArray)+1) />
<cf_dsp_attribute_form attributeBean="#newAttribute#" action="add" subTypeID="#attributes.subTypeID#" formName="newFrm">

<cfif arrayLen(attributesArray)>
<a href="javascript:;" style="display:none;" id="saveSort" onclick="saveAttributeSort('attributesList');return false;">[Save Order]</a>
<a href="javascript:;"  id="showSort" onclick="showSaveSort('attributesList');return false;">[Reorder]</a>
</cfif>

<p>
<cfif arrayLen(attributesArray)>
<ul id="attributesList">
<cfloop from="1" to="#arrayLen(attributesArray)#" index="a">	
<cfset attributeBean=attributesArray[a]/>
<cfoutput>
	<li attributeID="#attributeBean.getAttributeID()#">
		<span id="handle#a#" class="handle" style="display:none;">[Drag]</span>
		#attributeBean.getName()#
		<a title="Edit" href="javascript:;" id="editFrm#a#open" onclick="jQuery('##editFrm#a#container').slideDown();this.style.display='none';jQuery('##editFrm#a#close').show();return false;">[Edit]</a>
		<a title="Edit" href="javascript:;" style="display:none;" id="editFrm#a#close" onclick="jQuery('##editFrm#a#container').slideUp();this.style.display='none';jQuery('##editFrm#a#open').show();return false;">[Close]</a>
		<a title="Delete" href="index.cfm?fuseaction=cExtend.updateAttribute&action=delete&subTypeID=#URLEncodedFormat(attributes.subTypeID)#&extendSetID=#attributeBean.getExtendSetID()#&siteid=#URLEncodedFormat(attributes.siteid)#&attributeID=#attributeBean.getAttributeID()#" onClick="return confirmDialog('Delete the attribute #jsStringFormat("'#attributeBean.getname()#'")#?',this.href)">[Delete]</a>

	<div style="display:none;" id="editFrm#a#container">
		<cf_dsp_attribute_form attributeBean="#attributeBean#" action="edit" subTypeID="#attributes.subTypeID#" formName="editFrm#a#">
	</div>
	</li>
</cfoutput>
</cfloop>
</ul>

<cfelse>
<br/>
<em>This set has no attributes.</em>
</cfif>
</p>
</cfoutput>