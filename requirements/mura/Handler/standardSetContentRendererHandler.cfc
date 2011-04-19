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
	 <cfcomponent extends="Handler" output="false">
	
<cffunction name="handle" output="false" returnType="any">
	<cfargument name="event" required="true">
	<cfset var $=event.getValue("muraScope")>
	<cfset var themeRenderer="">
	<cfset event.setValue('contentRenderer',createObject("component","#event.getSite().getAssetMap()#.includes.contentRenderer").init(event=event,$=$,mura=$))/>
	<cfif fileExists(expandPath(event.getSite().getThemeIncludePath()) & "/contentRenderer.cfc")>
		<cfset themeRenderer=createObject("component","#event.getSite().getThemeAssetMap()#.contentRenderer").init()>
		<cfset themeRenderer.injectMethod("mura",$)>
		<cfset themeRenderer.injectMethod("$",$)>
		<cfset themeRenderer.injectMethod("event",event)>
		<cfset event.setValue("themeRenderer",themeRenderer)>
	</cfif>
</cffunction>

</cfcomponent>