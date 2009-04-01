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
<cfcomponent extends="mura.cfobject" output="false">

<cfset variables.instance=structNew() />
<cfset variables.instance.SiteID=""/>
<cfset variables.instance.Site=""/>
<cfset variables.instance.pageLimit=1000/>
<cfset variables.instance.Locking="None"/>
<cfset variables.instance.Domain=""/>
<cfset variables.instance.Contact=""/>
<cfset variables.instance.MailServerIP=""/>
<cfset variables.instance.MailServerSMTPPort="25"/>
<cfset variables.instance.MailServerPOPPort="110"/>
<cfset variables.instance.MailServerTLS="false"/>
<cfset variables.instance.MailServerSSL="false" />
<cfset variables.instance.MailServerUsername=""/>
<cfset variables.instance.MailServerUsernameEmail=""/>
<cfset variables.instance.MailServerPassword=""/>
<cfset variables.instance.useDefaultSMTPServer=0/>
<cfset variables.instance.EmailBroadcaster=0/>
<cfset variables.instance.EmailBroadcasterLimit=0/>
<cfset variables.instance.Extranet=0/>
<cfset variables.instance.ExtranetSSL=0/>
<cfset variables.instance.cache=0/>
<cfset variables.instance.ViewDepth=1/>
<cfset variables.instance.nextN=20/>
<cfset variables.instance.DataCollection=0/>
<cfset variables.instance.ColumnCount=3/>
<cfset variables.instance.ColumnNames="Left Column^Main Content^Right Column"/>
<cfset variables.instance.ExtranetPublicReg=0/>
<cfset variables.instance.PrimaryColumn=2/>
<cfset variables.instance.PublicSubmission=0/>
<cfset variables.instance.adManager=0/>
<cfset variables.instance.ContactName=""/>
<cfset variables.instance.ContactAddress=""/>
<cfset variables.instance.ContactCity=""/>
<cfset variables.instance.ContactState=""/>
<cfset variables.instance.ContactZip=""/>
<cfset variables.instance.ContactEmail=""/>
<cfset variables.instance.ContactPhone=""/>
<cfset variables.instance.PublicUserPoolID=""/>
<cfset variables.instance.PrivateUserPoolID=""/>
<cfset variables.instance.AdvertiserUserPoolID=""/>
<cfset variables.instance.DisplayPoolID=""/>
<cfset variables.instance.hasfeedManager=0/>
<cfset variables.instance.galleryMainScaleBy="y"/>
<cfset variables.instance.galleryMainScale=100/>
<cfset variables.instance.gallerySmallScaleBy="y"/>
<cfset variables.instance.gallerySmallScale=100/>
<cfset variables.instance.galleryMediumScaleBy="y"/>
<cfset variables.instance.galleryMediumScale=100/>
<cfset variables.instance.sendLoginScript=""/>
<cfset variables.instance.mailingListConfirmScript=""/>
<cfset variables.instance.publicSubmissionApprovalScript=""/>
<cfset variables.instance.reminderScript=""/>
<cfset variables.instance.ExtranetPublicRegNotify=""/>
<cfset variables.instance.exportLocation=""/>
<cfset variables.instance.loginURL=""/>
<cfset variables.instance.editProfileURL=""/>
<cfset variables.instance.commentApprovalDefault=1/>  
<cfset variables.instance.deploy=1/>  
<cfset variables.instance.lastDeployment=""/>
<cfset variables.instance.accountActivationScript=""/>
<cfset variables.instance.googleAPIKey=""/>
<cfset variables.instance.siteLocale=""/>
<cfset variables.instance.rbFactory=""/>    
<cfset variables.instance.javaLocale=""/> 
<cfset variables.instance.cacheFactory=""/> 
 
<cffunction name="init" returntype="any" output="false" access="public">
<cfargument name="configBean" type="any" required="yes"/>
<cfargument name="clusterManager" type="any" required="yes"/>
	<cfset variables.configBean=arguments.configBean />
	<cfset variables.clusterManager=arguments.clusterManager />
	<cfreturn this />
</cffunction>

<cffunction name="getErrors" returnType="struct" output="false" access="public">
	<cfreturn variables.instance.errors />
</cffunction>

<cffunction name="getAllValues" access="public" returntype="struct" output="false">
	<cfreturn variables.instance />
</cffunction>

<cffunction name="validate" access="public" output="false" returntype="void">
	<cfset variables.instance.errors=structnew() />
	
	<cfif getSiteID() eq "">
		<cfset variables.instance.errors.siteid="The 'SiteID' variable is required." />
	</cfif>
	
	<cfif getSiteID() eq "admin" or getSiteID() eq "tasks">
		<cfset variables.instance.errors.siteid="The 'SiteID' variable is invalid." />
	</cfif>
	
</cffunction>

<cffunction name="set" returnType="void" output="false" access="public">
		<cfargument name="data" type="any" required="true">

		<cfset var prop="" />
		
		<cfif isquery(arguments.data)>
		
			<cfset setSiteID(arguments.data.SiteID) />
			<cfset setSite(arguments.data.Site) />
			<cfset setpageLimit(arguments.data.pageLimit) />
			<cfset setLocking(arguments.data.Locking) />
			<cfset setDomain(arguments.data.Domain) />
			<cfset setExportLocation(arguments.data.ExportLocation) /> 
			<cfset setContact(arguments.data.Contact) />
			<cfset setUseDefaultSMTPServer(arguments.data.useDefaultSMTPServer) />
			<cfset setMailServerIP(arguments.data.MailServerIP) />
			<cfset setMailServerUsername(arguments.data.MailServerUsername) />
			<cfset setMailServerPassword(arguments.data.MailServerPassword) />
			<cfset setEmailBroadcaster(arguments.data.EmailBroadcaster) />
			<cfset setEmailBroadcasterLimit(arguments.data.EmailBroadcasterLimit) />
			<cfset setExtranet(arguments.data.Extranet) />
			<cfset setExtranetPublicReg(arguments.data.ExtranetPublicReg) />
			<cfset setExtranetSSL(arguments.data.ExtranetSSL) />
			<cfset setcache(arguments.data.cache) />
			<cfset setViewDepth(arguments.data.ViewDepth) />
			<cfset setnextN(arguments.data.nextN) />
			<cfset setDataCollection(arguments.data.DataCollection) />
			<cfset setColumnCount(arguments.data.ColumnCount) />
			<cfset setColumnNames(arguments.data.ColumnNames) />
			<cfset setPrimaryColumn(arguments.data.PrimaryColumn) />
			<cfset setPublicSubmission(arguments.data.PublicSubmission) />
			<cfset setadManager(arguments.data.adManager) />
			<cfset setContactName(arguments.data.ContactName) />
			<cfset setContactAddress(arguments.data.ContactAddress) />
			<cfset setContactCity(arguments.data.ContactCity) />
			<cfset setContactState(arguments.data.ContactState) />
			<cfset setContactZip(arguments.data.ContactZip) />
			<cfset setContactEmail(arguments.data.ContactEmail) />
			<cfset setContactPhone(arguments.data.ContactPhone) />
			<cfset setPublicUserPoolID(arguments.data.PublicUserPoolID) />
			<cfset setPrivateUserPoolID(arguments.data.PrivateUserPoolID) />
			<cfset setAdvertiserUserPoolID(arguments.data.AdvertiserUserPoolID) />
			<cfset setDisplayPoolID(arguments.data.DisplayPoolID) />
			<cfset setHasfeedManager(arguments.data.feedManager) />
			<cfset setGalleryMainScaleBy(arguments.data.GalleryMainScaleBy) />
			<cfset setGalleryMainScale(arguments.data.GalleryMainScale) />
			<cfset setGallerySmallScaleBy(arguments.data.GallerySmallScaleBy) />
			<cfset setGallerySmallScale(arguments.data.GallerySmallScale) />
			<cfset setGalleryMediumScaleBy(arguments.data.GalleryMediumScaleBy) />
			<cfset setGalleryMediumScale(arguments.data.GalleryMediumScale) />
			<cfset setSendLoginScript(arguments.data.sendLoginScript) />
			<cfset setMailingListConfirmScript(arguments.data.mailingListConfirmScript) />
			<cfset setPublicSubmissionApprovalScript(arguments.data.publicSubmissionApprovalScript) />
			<cfset setReminderScript(arguments.data.ReminderScript) />
			<cfset setExtranetPublicRegNotify(arguments.data.ExtranetPublicRegNotify) />
			<cfset setLoginURL(arguments.data.loginURL) />
			<cfset setEditProfileURL(arguments.data.EditProfileURL) />
			<cfset setCommentApprovalDefault(arguments.data.commentApprovalDefault) />
			<cfset setDeploy(arguments.data.deploy) />
			<cfset setLastDeployment(arguments.data.lastDeployment) />
			<cfset setAccountActivationScript(arguments.data.accountActivationScript) />
			<cfset setGoogleAPIKey(arguments.data.googleAPIKey) />
			<cfset setSiteLocale(arguments.data.siteLocale) />
			<cfset setMailServerSMTPPort(arguments.data.mailserverSMTPPort) />
			<cfset setMailServerPOPPort(arguments.data.mailserverPOPPort) />
			<cfset setMailServerTLS(arguments.data.mailserverTLS) />
			<cfset setMailServerSSL(arguments.data.mailserverSSL) />
			
		<cfelseif isStruct(arguments.data)>
		
			<cfloop collection="#arguments.data#" item="prop">
			<cfif isdefined("variables.instance.#prop#")>
				<cfset evaluate("set#prop#(arguments.data[prop])") />
			</cfif>
			</cfloop>
			
		</cfif>
		
			<cfif getPrivateUserPoolID() eq ''>
			<cfset setPrivateUserPoolID(getSiteID()) />
			</cfif>
			
			<cfif getPublicUserPoolID() eq ''>
			<cfset setPublicUserPoolID(getSiteID()) />
			</cfif>
			
			<cfif getAdvertiserUserPoolID() eq ''>
			<cfset setAdvertiserUserPoolID(getSiteID()) />
			</cfif>
			
			<cfif getDisplayPoolID() eq ''>
			<cfset setDisplayPoolID(getSiteID()) />
			</cfif>
		
		<cfset validate() />
		
 </cffunction>

<cffunction name="getSiteID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SiteID />
</cffunction>

<cffunction name="setSiteID" access="public" output="false">
	<cfargument name="SiteID" type="String" />
	<cfset variables.instance.SiteID = arguments.SiteID />
</cffunction>

<cffunction name="getSite" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Site />
</cffunction>

<cffunction name="setSite" access="public" output="false">
	<cfargument name="Site" type="String" />
	<cfset variables.instance.Site = arguments.Site />
</cffunction>

<cffunction name="getPageLimit" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.PageLimit />
</cffunction>

<cffunction name="setPageLimit" access="public" output="false">
	<cfargument name="PageLimit" type="Numeric" />
	<cfset variables.instance.PageLimit = arguments.PageLimit />
</cffunction>

<cffunction name="getLocking" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Locking />
</cffunction>

<cffunction name="setLocking" access="public" output="false">
	<cfargument name="Locking" type="String" />
	<cfset variables.instance.Locking = arguments.Locking />
</cffunction>

<cffunction name="getDomain" returntype="String" access="public" output="false">
	<cfargument name="mode" type="String" required="true" default="#application.configBean.getMode()#" />
	
	<cfif arguments.mode eq 'Staging'>
		<cfreturn application.configBean.getAdminDomain() />
	<cfelse>
		<cfreturn variables.instance.Domain />
	</cfif>
</cffunction>

<cffunction name="setDomain" access="public" output="false">
	<cfargument name="Domain" type="String" />
	<cfset variables.instance.Domain = arguments.Domain />
</cffunction>

<cffunction name="getExportLocation" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ExportLocation />
</cffunction>

<cffunction name="setExportLocation" access="public" output="false">
	<cfargument name="ExportLocation" type="String" />
	<cfset variables.instance.ExportLocation = arguments.ExportLocation />
</cffunction>

<cffunction name="getContact" returntype="String" access="public" output="false">
	<cfreturn variables.instance.Contact />
</cffunction>

<cffunction name="setContact" access="public" output="false">
	<cfargument name="Contact" type="String" />
	<cfset variables.instance.Contact = arguments.Contact />
</cffunction>

<cffunction name="getMailServerIP" returntype="String" access="public" output="false">
	<cfreturn variables.instance.MailServerIP />
</cffunction>

<cffunction name="setMailServerIP" access="public" output="false">
	<cfargument name="MailServerIP" type="String" />
	<cfset variables.instance.MailServerIP = arguments.MailServerIP />
</cffunction>

<cffunction name="setMailServerUsernameEmail" returntype="String" access="public" output="false">
	<cfargument name="MailServerUsernameEmail" type="String" />

	<cfif find("@",arguments.MailServerUsernameEmail)>	
		<cfset variables.instance.MailServerUsernameEmail=arguments.MailServerUsernameEmail />	
	<cfelseif find("+",arguments.MailServerUsernameEmail)>		
			<cfset variables.instance.MailServerUsernameEmail=replace(arguments.MailServerUsernameEmail,"+","@") />
	<cfelseif len(arguments.MailServerUsernameEmail)>
		<cfset variables.instance.MailServerUsernameEmail=arguments.MailServerUsernameEmail & "@" & listRest(variables.instance.MailServerIP,".") />
	<cfelse>
		<cfset variables.instance.MailServerUsernameEmail=variables.instance.contact />
	</cfif>
</cffunction>

<cffunction name="getMailServerUsernameEmail" returntype="String" access="public" output="false">
		<cfreturn variables.instance.mailServerUsernameEmail />	
</cffunction>

<cffunction name="getMailServerUsername" returntype="String" access="public" output="false">
	<cfargument name="forLogin" default="false" required="true">
	<cfif not arguments.forLogin or len(getMailServerPassword())>
		<cfreturn variables.instance.mailServerUsername />
	<cfelse>
		<cfreturn ""/>
	</cfif>
</cffunction>

<cffunction name="setMailServerUsername" access="public" output="false">
	<cfargument name="MailServerUsername" type="String" />
	<cfset setMailServerUsernameEmail(arguments.MailServerUsername) />
	<cfset variables.instance.mailServerUsername = arguments.MailServerUsername />
</cffunction>

<cffunction name="getMailServerPassword" returntype="String" access="public" output="false">
	<cfreturn variables.instance.MailServerPassword />
</cffunction>

<cffunction name="setMailServerPassword" access="public" output="false">
	<cfargument name="MailServerPassword" type="String" />
	<cfset variables.instance.MailServerPassword = arguments.MailServerPassword />
</cffunction>

<cffunction name="getEmailBroadcaster" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.EmailBroadcaster />
</cffunction>

<cffunction name="setEmailBroadcaster" access="public" output="false">
	<cfargument name="EmailBroadcaster" type="Numeric" />
	<cfset variables.instance.EmailBroadcaster = arguments.EmailBroadcaster />
</cffunction>

<cffunction name="getEmailBroadcasterLimit" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.EmailBroadcasterLimit />
</cffunction>

<cffunction name="setEmailBroadcasterLimit" access="public" output="false">
	<cfargument name="EmailBroadcasterLimit" type="Numeric" />
	<cfset variables.instance.EmailBroadcasterLimit = arguments.EmailBroadcasterLimit />
</cffunction>

<cffunction name="getExtranet" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.Extranet />
</cffunction>

<cffunction name="setExtranet" access="public" output="false">
	<cfargument name="Extranet" type="Numeric" />
	<cfset variables.instance.Extranet = arguments.Extranet />
</cffunction>

<cffunction name="getExtranetPublicReg" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.ExtranetPublicReg />
</cffunction>

<cffunction name="setExtranetPublicReg" access="public" output="false">
	<cfargument name="ExtranetPublicReg" type="Numeric" />
	<cfset variables.instance.ExtranetPublicReg = arguments.ExtranetPublicReg />
</cffunction>

<cffunction name="getExtranetSSL" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.ExtranetSSL />
</cffunction>

<cffunction name="setExtranetSSL" access="public" output="false">
	<cfargument name="ExtranetSSL" type="Numeric" />
	<cfset variables.instance.ExtranetSSL = arguments.ExtranetSSL />
</cffunction>

<cffunction name="getCache" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.Cache />
</cffunction>

<cffunction name="setCache" access="public" output="false">
	<cfargument name="Cache" type="Numeric" />
	<cfset variables.instance.Cache = arguments.Cache />
</cffunction>

<cffunction name="getViewDepth" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.ViewDepth />
</cffunction>

<cffunction name="setViewDepth" access="public" output="false">
	<cfargument name="ViewDepth" type="Numeric" />
	<cfset variables.instance.ViewDepth = arguments.ViewDepth />
</cffunction>

<cffunction name="getNextN" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.NextN />
</cffunction>

<cffunction name="setNextN" access="public" output="false">
	<cfargument name="NextN" type="Numeric" />
	<cfset variables.instance.NextN = arguments.NextN />
</cffunction>

<cffunction name="getDataCollection" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.DataCollection />
</cffunction>

<cffunction name="setDataCollection" access="public" output="false">
	<cfargument name="DataCollection" type="Numeric" />
	<cfset variables.instance.DataCollection = arguments.DataCollection />
</cffunction>

<cffunction name="getColumnCount" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.ColumnCount />
</cffunction>

<cffunction name="setColumnCount" access="public" output="false">
	<cfargument name="ColumnCount" type="Numeric" />
	<cfset variables.instance.ColumnCount = arguments.ColumnCount />
</cffunction>

<cffunction name="getColumnNames" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ColumnNames />
</cffunction>

<cffunction name="setColumnNames" access="public" output="false">
	<cfargument name="ColumnNames" type="String" />
	<cfset variables.instance.ColumnNames = arguments.ColumnNames />
</cffunction>

<cffunction name="getPrimaryColumn" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.PrimaryColumn />
</cffunction>

<cffunction name="setPrimaryColumn" access="public" output="false">
	<cfargument name="PrimaryColumn" type="Numeric" />
	<cfset variables.instance.PrimaryColumn = arguments.PrimaryColumn />
</cffunction>

<cffunction name="getPublicSubmission" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.PublicSubmission />
</cffunction>

<cffunction name="setPublicSubmission" access="public" output="false">
	<cfargument name="PublicSubmission" type="Numeric" />
	<cfset variables.instance.PublicSubmission = arguments.PublicSubmission />
</cffunction>

<cffunction name="getAdManager" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.AdManager />
</cffunction>

<cffunction name="setAdManager" access="public" output="false">
	<cfargument name="AdManager" type="Numeric" />
	<cfset variables.instance.AdManager = arguments.AdManager />
</cffunction>

<cffunction name="getContactName" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ContactName />
</cffunction>

<cffunction name="setContactName" access="public" output="false">
	<cfargument name="ContactName" type="String" />
	<cfset variables.instance.ContactName = arguments.ContactName />
</cffunction>

<cffunction name="getContactAddress" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ContactAddress />
</cffunction>

<cffunction name="setContactAddress" access="public" output="false">
	<cfargument name="ContactAddress" type="String" />
	<cfset variables.instance.ContactAddress = arguments.ContactAddress />
</cffunction>

<cffunction name="getContactCity" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ContactCity />
</cffunction>

<cffunction name="setContactCity" access="public" output="false">
	<cfargument name="ContactCity" type="String" />
	<cfset variables.instance.ContactCity = arguments.ContactCity />
</cffunction>

<cffunction name="getContactState" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ContactState />
</cffunction>

<cffunction name="setContactState" access="public" output="false">
	<cfargument name="ContactState" type="String" />
	<cfset variables.instance.ContactState = arguments.ContactState />
</cffunction>

<cffunction name="getContactZip" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ContactZip />
</cffunction>

<cffunction name="setContactZip" access="public" output="false">
	<cfargument name="ContactZip" type="String" />
	<cfset variables.instance.ContactZip = arguments.ContactZip />
</cffunction>

<cffunction name="getContactEmail" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ContactEmail />
</cffunction>

<cffunction name="setContactEmail" access="public" output="false">
	<cfargument name="ContactEmail" type="String" />
	<cfset variables.instance.ContactEmail = arguments.ContactEmail />
</cffunction>

<cffunction name="getContactPhone" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ContactPhone />
</cffunction>

<cffunction name="setContactPhone" access="public" output="false">
	<cfargument name="ContactPhone" type="String" />
	<cfset variables.instance.ContactPhone = arguments.ContactPhone />
</cffunction>

<cffunction name="getPublicUserPoolID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.PublicUserPoolID />
</cffunction>

<cffunction name="setPublicUserPoolID" access="public" output="false">
	<cfargument name="PublicUserPoolID" type="String" />
	<cfset variables.instance.PublicUserPoolID = arguments.PublicUserPoolID />
</cffunction>

<cffunction name="getPrivateUserPoolID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.PrivateUserPoolID />
</cffunction>

<cffunction name="setPrivateUserPoolID" access="public" output="false">
	<cfargument name="PrivateUserPoolID" type="String" />
	<cfset variables.instance.PrivateUserPoolID = arguments.PrivateUserPoolID />
</cffunction>

<cffunction name="getAdvertiserUserPoolID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.AdvertiserUserPoolID />
</cffunction>

<cffunction name="setAdvertiserUserPoolID" access="public" output="false">
	<cfargument name="AdvertiserUserPoolID" type="String" />
	<cfset variables.instance.AdvertiserUserPoolID = arguments.AdvertiserUserPoolID />
</cffunction>


<cffunction name="getHasfeedManager" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.hasfeedManager />
</cffunction>

<cffunction name="setHasfeedManager" access="public" output="true">
	<cfargument name="hasfeedManager" type="any" required="yes" default="0" />
	<cfset variables.instance.hasfeedManager = arguments.hasfeedManager />
</cffunction>

<cffunction name="getDisplayPoolID" returntype="String" access="public" output="false">
	<cfreturn variables.instance.DisplayPoolID />
</cffunction>

<cffunction name="setDisplayPoolID" access="public" output="false">
	<cfargument name="DisplayPoolID" type="String" />
	<cfset variables.instance.DisplayPoolID = arguments.DisplayPoolID />
</cffunction>

<cffunction name="getGalleryMainScaleBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.GalleryMainScaleBy />
</cffunction>

<cffunction name="setGalleryMainScaleBy" access="public" output="false">
	<cfargument name="GalleryMainScaleBy" type="String" />
	<cfset variables.instance.GalleryMainScaleBy = arguments.GalleryMainScaleBy />
</cffunction>

<cffunction name="getGalleryMainScale" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.GalleryMainScale />
</cffunction>

<cffunction name="setGalleryMainScale" access="public" output="true">
	<cfargument name="GalleryMainScale" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.GalleryMainScale)>
		<cfset variables.instance.GalleryMainScale = arguments.GalleryMainScale />
	</cfif>
</cffunction>

<cffunction name="getGallerySmallScaleBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.GallerySmallScaleBy />
</cffunction>

<cffunction name="setGallerySmallScaleBy" access="public" output="false">
	<cfargument name="GallerySmallScaleBy" type="String" />
	<cfset variables.instance.GallerySmallScaleBy = arguments.GallerySmallScaleBy />
</cffunction>

<cffunction name="getGallerySmallScale" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.GallerySmallScale />
</cffunction>

<cffunction name="setGallerySmallScale" access="public" output="true">
	<cfargument name="GallerySmallScale" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.GallerySmallScale)>
		<cfset variables.instance.GallerySmallScale = arguments.GallerySmallScale />
	</cfif>
</cffunction>

<cffunction name="getGalleryMediumScaleBy" returntype="String" access="public" output="false">
	<cfreturn variables.instance.GalleryMediumScaleBy />
</cffunction>

<cffunction name="setGalleryMediumScaleBy" access="public" output="false">
	<cfargument name="GalleryMediumScaleBy" type="String" />
	<cfset variables.instance.GalleryMediumScaleBy = arguments.GalleryMediumScaleBy />
</cffunction>

<cffunction name="getGalleryMediumScale" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.GalleryMediumScale />
</cffunction>

<cffunction name="setGalleryMediumScale" access="public" output="true">
	<cfargument name="GalleryMediumScale" type="any" required="yes" default="0" />
	<cfif isNumeric(arguments.GalleryMediumScale)>
		<cfset variables.instance.GalleryMediumScale = arguments.GalleryMediumScale />
	</cfif>
</cffunction>

<cffunction name="getSendLoginScript" returntype="String" access="public" output="false">
	<cfreturn variables.instance.SendLoginScript />
</cffunction>

<cffunction name="setSendLoginScript" access="public" output="false">
	<cfargument name="SendLoginScript" type="String" />
	<cfset variables.instance.SendLoginScript = trim(arguments.SendLoginScript) />
</cffunction>

<cffunction name="getMailingListConfirmScript" returntype="String" access="public" output="false">
	<cfreturn variables.instance.MailingListConfirmScript />
</cffunction>

<cffunction name="setMailingListConfirmScript" access="public" output="false">
	<cfargument name="MailingListConfirmScript" type="String" />
	<cfset variables.instance.MailingListConfirmScript = trim(arguments.MailingListConfirmScript) />
</cffunction>

<cffunction name="getPublicSubmissionApprovalScript" returntype="String" access="public" output="false">
	<cfreturn variables.instance.PublicSubmissionApprovalScript />
</cffunction>

<cffunction name="setPublicSubmissionApprovalScript" access="public" output="false">
	<cfargument name="PublicSubmissionApprovalScript" type="String" />
	<cfset variables.instance.PublicSubmissionApprovalScript = trim(arguments.PublicSubmissionApprovalScript) />
</cffunction>

<cffunction name="getReminderScript" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ReminderScript />
</cffunction>

<cffunction name="setReminderScript" access="public" output="false">
	<cfargument name="ReminderScript" type="String" />
	<cfset variables.instance.ReminderScript = trim(arguments.ReminderScript) />
</cffunction>

<cffunction name="getExtranetPublicRegNotify" returntype="String" access="public" output="false">
	<cfreturn variables.instance.ExtranetPublicRegNotify />
</cffunction>

<cffunction name="setExtranetPublicRegNotify" access="public" output="false">
	<cfargument name="ExtranetPublicRegNotify" type="String" />
	<cfset variables.instance.ExtranetPublicRegNotify = trim(arguments.ExtranetPublicRegNotify) />
</cffunction>

<cffunction name="getLoginURL" returntype="String" access="public" output="false">
	<cfif variables.instance.loginURL neq ''>
	<cfreturn variables.instance.LoginURL />
	<cfelse>
	<cfreturn "#application.configBean.getIndexFile()#?display=login" />
	</cfif>
</cffunction>

<cffunction name="setLoginURL" access="public" output="false">
	<cfargument name="LoginURL" type="String" />
	<cfset variables.instance.LoginURL = trim(arguments.LoginURL) />
</cffunction>

<cffunction name="getEditProfileURL" returntype="String" access="public" output="false">
	<cfif variables.instance.EditProfileURL neq ''>
	<cfreturn variables.instance.EditProfileURL />
	<cfelse>
	<cfreturn "#application.configBean.getIndexFile()#?display=editProfile" />
	</cfif>
</cffunction>

<cffunction name="setEditProfileURL" access="public" output="false">
	<cfargument name="EditProfileURL" type="String" />
	<cfset variables.instance.EditProfileURL = trim(arguments.EditProfileURL) />
</cffunction>

<cffunction name="getCommentApprovalDefault" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.CommentApprovalDefault />
</cffunction>

<cffunction name="setCommentApprovalDefault" access="public" output="false">
	<cfargument name="CommentApprovalDefault" type="Numeric" />
	<cfset variables.instance.CommentApprovalDefault = arguments.CommentApprovalDefault />
</cffunction>

<cffunction name="getDeploy" returntype="Numeric" access="public" output="false">
	<cfreturn variables.instance.deploy />
</cffunction>

<cffunction name="setDeploy" access="public" output="false">
	<cfargument name="deploy" type="Numeric" />
	<cfset variables.instance.deploy = arguments.deploy />
</cffunction>

<cffunction name="getLastDeployment" returntype="String" access="public" output="false">

	<cfreturn variables.instance.LastDeployment />
	
</cffunction>

<cffunction name="setLastDeployment" access="public" output="false">
	<cfargument name="LastDeployment" type="String" />
	<cfif isDate(arguments.LastDeployment)>
	<cfset variables.instance.LastDeployment = parseDateTime(arguments.LastDeployment) />
	<cfelse>
	<cfset variables.instance.LastDeployment = ""/>
	</cfif>
</cffunction>

<cffunction name="getAccountActivationScript" returntype="String" access="public" output="false">

	<cfreturn variables.instance.accountActivationScript />
	
</cffunction>

<cffunction name="setAccountActivationScript" access="public" output="false">
	<cfargument name="accountActivationScript" type="String" />
	<cfset variables.instance.accountActivationScript = trim(arguments.accountActivationScript) />
</cffunction>

<cffunction name="getGoogleAPIKey" returntype="String" access="public" output="false">
	<cfreturn variables.instance.GoogleAPIKey />
</cffunction>

<cffunction name="setGoogleAPIKey" access="public" output="false">
	<cfargument name="GoogleAPIKey" type="String" />
	<cfset variables.instance.GoogleAPIKey = arguments.GoogleAPIKey />
</cffunction>

<cffunction name="setUseDefaultSMTPServer" access="public" output="false">
	<cfargument name="UseDefaultSMTPServer"  />
	
	<cfif isNumeric(arguments.UseDefaultSMTPServer)>
		<cfset variables.instance.UseDefaultSMTPServer = arguments.UseDefaultSMTPServer />
	</cfif>
</cffunction>

<cffunction name="getUseDefaultSMTPServer" returntype="numeric" access="public" output="false">
	<cfreturn variables.instance.UseDefaultSMTPServer />
</cffunction>

<cffunction name="getSiteLocale" returntype="String" access="public" output="false">
	<cfreturn variables.instance.siteLocale />
</cffunction>

<cffunction name="setSiteLocale" access="public" output="false">
	<cfargument name="siteLocale" type="String" />
	<cfset variables.instance.siteLocale = arguments.siteLocale />
</cffunction>

<cffunction name="getMailServerSMTPPort" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mailServerSMTPPort />
</cffunction>

<cffunction name="setMailServerSMTPPort" access="public" output="false">
	<cfargument name="mailServerPort" type="String" />
	<cfif isNumeric(arguments.mailServerPort)>
	<cfset variables.instance.mailServerSMTPPort = arguments.mailServerPort />
	</cfif>
</cffunction>

<cffunction name="getMailServerPOPPort" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mailServerPOPPort />
</cffunction>

<cffunction name="setMailServerPOPPort" access="public" output="false">
	<cfargument name="mailServerPort" type="String" />
	<cfif isNumeric(arguments.mailServerPort)>
	<cfset variables.instance.mailServerPOPPort = arguments.mailServerPort />
	</cfif>
</cffunction>

<cffunction name="getMailServerTLS" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mailServerTLS />
</cffunction>

<cffunction name="setMailServerTLS" access="public" output="false">
	<cfargument name="mailServerTLS" type="String" />
	<cfif isBoolean(arguments.mailServerTLS)>
	<cfset variables.instance.mailServerTLS = arguments.mailServerTLS />
	</cfif>
</cffunction>

<cffunction name="getMailServerSSL" returntype="String" access="public" output="false">
	<cfreturn variables.instance.mailServerSSL />
</cffunction>

<cffunction name="setMailServerSSL" access="public" output="false">
	<cfargument name="mailServerSSL" type="String" />
	<cfif isBoolean(arguments.mailServerSSL)>
	<cfset variables.instance.mailServerSSL = arguments.mailServerSSL />
	</cfif>
</cffunction>


<cffunction name="getJavaLocale" returntype="String" access="public" output="false">
	
	<cfif not len(variables.instance.javaLocale)>
		<cfif len(getSiteLocale())>
			<cfset variables.instance.javaLocale=application.rbFactory.CF2Java(getSiteLocale())>
		<cfelse>
			<cfset variables.instance.javaLocale=application.rbFactory.CF2Java(variables.configBean.getDefaultLocale())>
		</cfif>
	</cfif>
	
	<cfreturn variables.instance.javaLocale />
</cffunction>

<cffunction name="getCacheFactory" returntype="any" access="public" output="false">
	
	<cfif isObject(variables.instance.cacheFactory)>
		<cfreturn variables.instance.cacheFactory />
	<cfelse>
		<cfset variables.instance.cacheFactory=createObject("component","mura.cache.cacheFactory").init()>
		<cfreturn variables.instance.cacheFactory />
	</cfif>
	
</cffunction>

<cffunction name="purgeCache" returntype="void" access="public" output="false">
	
	<cfif isObject(variables.instance.cacheFactory)>
		<cfset variables.instance.cacheFactory.purgeAll() />
	</cfif>
	
	<cfset variables.clusterManager.purgeCache(getSiteID())>
	
</cffunction>

<cffunction name="getRBFactory" returntype="any" access="public" output="false">
	
	<cfif not isObject(variables.instance.rbFactory)>
		<cfset variables.instance.rbFactory=createObject("component","mura.resourceBundle.resourceBundleFactory").init(application.rbFactory,"#application.configBean.getWebRoot()#/#getSiteID()#/includes/resourceBundles/",getJavaLocale()) />
	</cfif>
	
	<cfreturn variables.instance.rbFactory />
</cffunction>
</cfcomponent>