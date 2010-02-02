<!--- This file is part of Mura CMS.

    Mura CMS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, Version 2 of the License.

    Mura CMS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>.
	
	As a special exception to the terms and conditions of version 2.0 of
	the GPL, you may redistribute this Program as described in Mura CMS'
	Plugin exception. You should have recieved a copy of the text describing
	this exception, and it is also available here:
	'http://www.getmura.com/exceptions.txt"

	 --->
<cfcomponent extends="Translator" output="false">
	
<cffunction name="translate" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset var page = "" />
	<cfset var renderer=event.getValue("contentRenderer") />
	<cfset var themePath=event.getSite().getThemeAssetPath()  />
	<cfset var $=event.getValue("MuraScope")>
	
	<cfset event.setValue('themePath',themePath)>
	
	<cfsavecontent variable="page">
		<cfinclude template="#event.getSite().getTemplateIncludePath()#/#renderer.getTemplate()#">
	</cfsavecontent>
		
	<cfset renderer.renderHTMLHeadQueue() />
	<cfset event.setValue('__MuraResponse__',page)>
</cffunction>

</cfcomponent>