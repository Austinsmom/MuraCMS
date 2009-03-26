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

<cffunction name="init" returntype="any" access="public" output="false">
	<cfargument name="configBean" type="any" required="yes"/>
	<cfargument name="utility" type="any" required="yes"/>
	<cfargument name="settingsManager" type="any" required="yes"/>
	<cfargument name="userDAO" type="any" required="yes"/>
	<cfargument name="mailer" type="any" required="yes"/>
	<cfargument name="pluginManager" type="any" required="yes"/>
		<cfset variables.configBean=arguments.configBean />
		<cfset variables.globalUtility=arguments.utility />
		<cfset variables.settingsManager=arguments.settingsManager />
		<cfset variables.userDAO=arguments.userDAO />
		<cfset variables.mailer=arguments.mailer />
		<cfset variables.pluginManager=arguments.pluginManager />
	<cfreturn this />
</cffunction>
	
<cffunction name="getUserData" returntype="query" access="public">
	<cfargument name="userid" type="string" default="#listfirst(getAuthUser(),"^")#">
	<cfset var rsuser=""/>
	<cfquery name="rsuser" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
	select * from tusers where userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#">
	</cfquery>
	<cfreturn rsuser>
</cffunction>

<cffunction name="login" returntype="boolean">
		<cfargument name="username" type="string" required="true" default="">
		<cfargument name="password" type="string" required="true" default="">
		<cfargument name="siteid" type="string" required="false" default="">
		<cfset var rolelist = "" />
		<cfset var rsUser = "" />
		<cfset var user = "" />
		<cfset var group = "" />
		<cfset var lastLogin = now() />
		<cfset var pluginEvent = createObject("component","mura.event") />
		
		<cflogout>
		<cfparam name="session.loginAttempts" type="numeric" default="0" />
		<cfparam name="session.blockLoginUntil" type="string" default="" />
		
		<cfset pluginEvent.setValue("username",arguments.username)>
		<cfset pluginEvent.setValue("password",arguments.password)>
		<cfset pluginEvent.setValue("siteid",arguments.siteid)>
		
		<cfif len(arguments.siteID)>
			<cfset variables.pluginManager.executeScripts('onSiteLogin',arguments.siteID,pluginEvent)/>
		<cfelse>
			<cfset variables.pluginManager.executeScripts('onGlobalLogin',arguments.siteID,pluginEvent)/>
		</cfif>
		
		<cfset variables.pluginManager.executeScripts('onGlobalLogin',arguments.siteID,pluginEvent)/>
		
		<cfquery datasource="#application.configBean.getDatasource()#" name="rsUser" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		SELECT UserID, Lname, Fname,username, Password, s2, LastLogin,company, ispublic, siteid,passwordCreated,subType FROM tusers WHERE
		username=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.username)#"> AND Password=<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(trim(arguments.password))#"> AND Type = 2 
		and inactive=0
		</cfquery>
		
		<cfif len(cgi.HTTP_COOKIE) and rsUser.RecordCount GREATER THAN 0
			and (not isDate(session.blockLoginUntil) 
			or (isDate(session.blockLoginUntil) and session.blockLoginUntil lt now()))>
			
				<cfif rsUser.isPublic and (arguments.siteid eq '' or variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID() neq rsUser.siteid)>
					
					<cfif session.loginAttempts lt 4>
						<cfset session.loginAttempts=session.loginAttempts+1 />
					<cfelse>
						<cfset session.blockLoginUntil=dateAdd("n",30,now())/>
						<cfset session.loginAttempts=0 />
					</cfif>
										
					<cfreturn false  >
				</cfif>				
					
				<cfset session.loginAttempts=0 />
				<cfset session.blockLoginUntil=""/>
				
				<cfset loginByQuery(rsUser)/>
					
				<cfreturn true />
		
		<cfelse>
			<cfif session.loginAttempts lt 4>
				<cfset session.loginAttempts=session.loginAttempts+1 />
			<cfelse>
				<cfset session.blockLoginUntil=dateAdd("n",30,now())/>
				<cfset session.loginAttempts=0 />
			</cfif>	
		</cfif>
						
		<cfreturn false />
</cffunction>
	
<cffunction name="loginByUserID" returntype="boolean">
		<cfargument name="userid" type="string" required="true" default="">
		<cfargument name="siteid" type="string" required="false" default="">
		<cfset var rolelist = "" />
		<cfset var rsUser = "" />
		<cfset var user = "" />
		<cfset var group = "" />
		<cfset var lastLogin = now() />
		
		<cflogout>
		<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#" name="rsUser">
		SELECT UserID, Lname, Fname,username, Password, s2, LastLogin,company, ispublic, siteid,passwordCreated FROM tusers WHERE userid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userID#"> AND Type = 2
		and inactive=0
		</cfquery>
		
		
			<cfif rsUser.RecordCount GREATER THAN 0>
			
				<cfif rsUser.isPublic and variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID() neq rsUser.siteid>
					<cfreturn false  >
				</cfif>				
			
				<cfset loginByQuery(rsUser)/>
				
				<cfreturn true />
		</cfif>
				
		<cfreturn false />
	</cffunction>

<cffunction name="loginByQuery">
<cfargument name="rsUser"/>
		<cfset var rolelist = "" />
		<cfset var group = "" />
		<cfset var lastLogin = now() />
		<cfset var rsGetRoles = "" />
		<cfset var user=""/>

				<cfquery name="RsGetRoles" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				Select groupname, isPublic, siteid from tusers where userid in
				(Select GroupID from tusersmemb where userid='#rsuser.userid#')
				</cfquery>
				
				<cfloop query="rsGetRoles">
					<cfset rolelist=listappend(rolelist, "#rsGetRoles.groupname#;#rsGetRoles.siteid#;#rsGetRoles.isPublic#")>
				</cfloop>
							
				<cfif not rsUser.isPublic>
					<cfset rolelist=listappend(rolelist, 'S2IsPrivate;#rsuser.siteid#')>
					<cfset rolelist=listappend(rolelist, 'S2IsPrivate')>
				<cfelse>
					<cfset rolelist=listappend(rolelist, 'S2IsPublic;#rsuser.siteid#')>
					<cfset rolelist=listappend(rolelist, 'S2IsPublic')>
				</cfif>
					
				<cfif rsuser.s2>
					<cfset rolelist=listappend(rolelist, 'S2')>
				</cfif>
				
				<cfif isDate(rsuser.lastLogin)>
					<cfset lastLogin=rsuser.lastLogin/>
				</cfif>
				
				<cfif rsuser.company neq ''>
					<cfset group=rsuser.company>
				<cfelse>
					<cfset group="#rsUser.Fname# #rsUser.Lname#">
				</cfif>
				
				<cfif rsuser.lname eq '' and rsuser.fname eq ''>
					<cfset user=rsuser.company>
				<cfelse>
					<cfset user="#rsUser.Fname# #rsUser.Lname#">
				</cfif>
				
				<cflogin>
				<cfloginuser name="#rsuser.userID#^#user#^#dateFormat(lastLogin,'m/d/yy')#^#group#^#rsUser.username#^#dateFormat(rsUser.passwordCreated,'m/d/yy')#^#rsUser.password#"
				 roles="#rolelist#"
				 password="#rsUser.password#">
				</cflogin>
				
				<cfquery datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
				UPDATE tusers SET LastLogin = #createodbcdatetime(now())#
				WHERE tusers.UserID='#rsUser.UserID#'
				</cfquery>
				
				<cfset variables.globalUtility.logEvent("UserID:#rsuser.userid# Name:#rsuser.fname# #rsuser.lname# logged in at #now()#","mura-users","Information",true) />


</cffunction>

<cffunction name="getUserByEmail" returntype="query" output="false">
	<cfargument name="email" type="string">
	<cfargument name="siteid" type="string" required="yes" default="">
	<cfset var rsCheck=""/>
	
		<cfquery name="rsCheck" datasource="#variables.configBean.getDatasource()#" username="#variables.configBean.getDBUsername()#" password="#variables.configBean.getDBPassword()#">
		select userID, username,password,email,fname,lname from tusers where type=2 and inactive=0 and email=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.email)#">
		<cfif arguments.siteid neq ''>
		and (
		(siteid='#variables.settingsManager.getSite(arguments.siteid).getPrivateUserPoolID()#' and isPublic=0)
		or
		(siteid='#variables.settingsManager.getSite(arguments.siteid).getPublicUserPoolID()#' and isPublic=1)
		)
		<cfelse>
		and isPublic=0
		</cfif>
		</cfquery>
		
	<cfreturn rsCheck>
	</cffunction>

<cffunction name="sendLoginByEmail" output="false" returntype="string"  access="public">
	<cfargument name="email" type="string">
	<cfargument name="siteid" type="string" required="yes" default="">
	<cfargument name="returnURL" type="string" required="yes" default="#cgi.SERVER_NAME##cgi.SCRIPT_NAME#">
	<cfset var msg="No account currently exists with the email address '#arguments.email#'.">
	<cfset var struser=structnew()>
	<cfset var rsuser = ""/>
	<cfset var userBean = ""/>
		<cfif REFindNoCase("^[^@%*<>' ]+@[^@%*<>' ]{2,255}\.[^@%*<>' ]{2,5}", trim(arguments.email)) neq 0>
					<cfset rsuser=getUserByEmail('#arguments.email#','#arguments.siteid#')>
					<cfif rsuser.recordcount>
						<cfloop query="rsuser">
						<cfset userBean=variables.userDAO.read(rsuser.userid)>
						<cfset userBean.setPassword(getRandomPassword()) />
						<cfset variables.userDAO.savePassword(userBean.getUserID(),userBean.getPassword()) /> 
							<cfif userBean.getUsername() neq '' and userBean.getPassword() neq ''>
								<cfset struser.username=userBean.getUsername()>
								<cfset struser.fname=userBean.getFname()>
								<cfset struser.lname=userBean.getLname()>
								<cfset struser.password=userBean.getPassword()>
								<cfset struser.fieldnames='Username,Password'>
								<cfif arguments.siteid eq ''>
									<cfset struser.from= variables.configBean.getTitle()/>
								<cfelse>
									<cfset struser.from=variables.settingsManager.getSite(arguments.siteid).getSite()>
								</cfif>
								
								<cfset sendLogin(struser,'#arguments.email#','#struser.from#','#struser.from# Account Information','#arguments.siteid#','')>
								<cfset msg="Your account information has been sent to you.">
							</cfif>
						</cfloop>
					</cfif>
		<cfelse>
					<cfset  msg="The email address '#arguments.email#' is not a valid format.">
		</cfif>
	<cfreturn msg>
	</cffunction>
	
<cffunction name="sendLoginByUser" output="false" returntype="boolean"  access="public">
	<cfargument name="userBean" type="any">
	<cfargument name="siteid" type="string" required="yes" default="" >
	<cfargument name="returnURL" type="string" required="yes" default="#cgi.SERVER_NAME##cgi.SCRIPT_NAME#">
	<cfargument name="isPublicReg" required="yes" type="boolean" default="false"/>
	
	<cfset var struser=structnew()>
	<cfset var bcc="">
	
		<cfset arguments.userBean.setPassword(getRandomPassword()) />
		<cfset variables.userDAO.savePassword(arguments.userBean.getUserID(),arguments.userBean.getPassword()) />
	
		<cfset struser.username=arguments.userBean.getUserName()>
		<cfset struser.password=arguments.userBean.getPassword()>
		<cfset struser.fname=arguments.userBean.getFname()>
		<cfset struser.lname=arguments.userBean.getLname()>
		<cfset struser.fieldnames='Username,Password'>
		<cfif arguments.siteid eq ''>
			<cfset struser.from= variables.configBean.getTitle()/>
		<cfelse>
			<cfset struser.from=variables.settingsManager.getSite(arguments.siteid).getSite()>
		</cfif>
	
		<cfif arguments.isPublicReg and variables.settingsManager.getSite(arguments.siteid).getExtranetPublicRegNotify() neq ''>
			<cfset bcc=variables.settingsManager.getSite(arguments.siteid).getExtranetPublicRegNotify()>
		</cfif>
								
		<cfset sendLogin(struser,'#arguments.userBean.getEmail()#','#struser.from#','#struser.from# Account Information','#arguments.siteid#','',bcc)>
	
	<cfreturn true/>
</cffunction>

<cffunction name="sendLogin" returntype="void" output="false">
<cfargument name="args" type="struct" default="#structnew()#">
<cfargument name="sendto" type="string" default="">
<cfargument name="from" type="string" default="">
<cfargument name="subject" type="string" default="">
<cfargument name="siteid" type="string" default="">
<cfargument name="reply" required="yes" type="string" default="">
<cfargument name="bcc"  required="yes" type="string" default="">

<cfset var sendLoginScript=""/>
<cfset var mailText=""/>
<cfset var username=arguments.args.username/>
<cfset var password=arguments.args.password/>
<cfset var firstname=arguments.args.fname/>
<cfset var lastname=arguments.args.lname/>
<cfset var contactEmail=""/>
<cfset var contactName=""/>
<cfset var finder=""/>
<cfset var theString=""/>

	<cfif arguments.siteid neq ''>
		<cfset sendLoginScript = variables.settingsManager.getSite(arguments.siteid).getSendLoginScript()/>
		<cfset contactEmail=variables.settingsManager.getSite(arguments.siteid).getContact()/>
		<cfset contactName=variables.settingsManager.getSite(arguments.siteid).getSite()/>
	<cfelse>
		<cfset contactEmail=variables.configBean.getAdminEmail()/>
		<cfset contactName=variables.configBean.getTitle()/>
	</cfif>


<cfif sendLoginScript neq ''>

	<cfset theString = sendLoginScript/>
	<cfset finder=refind('##.+?##',theString,1,"true")>
	<cfloop condition="#finder.len[1]#">
		<cftry>
			<cfset theString=replace(theString,mid(theString, finder.pos[1], finder.len[1]),'#trim(evaluate(mid(theString, finder.pos[1], finder.len[1])))#')>
			<cfcatch>
				<cfset theString=replace(theString,mid(theString, finder.pos[1], finder.len[1]),'')>
			</cfcatch>
		</cftry>
		<cfset finder=refind('##.+?##',theString,1,"true")>
	</cfloop>
	<cfset sendLoginScript = theString/>
	

	<cfsavecontent variable="mailText">
<cfoutput>#sendLoginScript#</cfoutput>
	</cfsavecontent>

<cfelse>
	<cfsavecontent variable="mailText">
<cfoutput>Dear #firstname#,

You've requested your login information be sent to you.

Username: #username#
Password: #password#

Please contact #contactEmail# if you
have any questions or comments on this process.

Thank you,

The #contactName# staff</cfoutput>
	</cfsavecontent>
</cfif>

<cfset variables.mailer.sendText(mailText,
				arguments.sendto,
				arguments.from,
				arguments.subject,
				arguments.siteid
				) />


</cffunction>

<cffunction name="sendActivationNotification" returntype="void" output="false">
<cfargument name="userBean" type="any">

<cfset var accountactivationscript=""/>
<cfset var sendLoginScript=""/>
<cfset var mailText=""/>
<cfset var contactEmail=""/>
<cfset var contactName=""/>
<cfset var firstName=""/>
<cfset var lastName=""/>
<cfset var username=""/>
<cfset var finder=""/>
<cfset var theString=""/>

<cfset accountActivationScript = variables.settingsManager.getSite(arguments.userBean.getSiteID()).getAccountActivationScript()/>
<cfset contactEmail=variables.settingsManager.getSite(arguments.userBean.getSiteID()).getContact()/>
<cfset contactName=variables.settingsManager.getSite(arguments.userBean.getSiteID()).getSite()/>
<cfset firstName=arguments.userBean.getFname() />
<cfset lastName=arguments.userBean.getLname() />
<cfset username=arguments.userBean.getUsername() />
	
<cfif accountActivationScript neq ''>
	<cfset theString = accountActivationScript />
	<cfset finder=refind('##.+?##',theString,1,"true")>
	<cfloop condition="#finder.len[1]#">
		<cftry>
			<cfset theString=replace(theString,mid(theString, finder.pos[1], finder.len[1]),'#trim(evaluate(mid(theString, finder.pos[1], finder.len[1])))#')>
			<cfcatch>
				<cfset theString=replace(theString,mid(theString, finder.pos[1], finder.len[1]),'')>
			</cfcatch>
		</cftry>
		<cfset finder=refind('##.+?##',theString,1,"true")>
	</cfloop>
	<cfset accountActivationScript = theString/>


<cfset variables.mailer.sendText(accountActivationScript,
				arguments.userBean.getEmail(),
				variables.settingsManager.getSite(arguments.userBean.getSiteID()).getSite(),
				"Your website account at #variables.settingsManager.getSite(arguments.userBean.getSiteID()).getSite()# is now active",
				arguments.userBean.getSiteID()
				) />


</cfif>	

</cffunction>
	
<cffunction name="getRandomPassword" access="public" returntype="string" output="false">
	<cfargument name="Length" default="6" required="yes" type="numeric">
	<cfargument name="CharSet" default="Alpha" required="yes" type="string">
	<cfargument name="Ucase" default="no" required="yes" type="string">
	
	<cfset var alphaLcase = "a|c|e|g|i|k|m|o|q|s|u|w|y|b|d|f|h|j|l|n|p|r|t|v|x|z">
	<cfset var alphaUcase = "A|C|E|G|I|K|M|O|Q|S|U|W|Y|B|D|F|H|J|L|N|P|R|T|V|X|Z">
	<cfset var numeric =    "0|2|4|6|8|9|7|5|3|1">
	<cfset var ThisPass="">
	<cfset var charlist=""/>
	<cfset var thisNum=0/>
	<cfset var thisChar=""/>
	<cfset var i=0/>
	
	<cfswitch expression="#arguments.CharSet#">
	
	 <cfcase value="alpha">
	  <cfset charlist = alphaLcase>
	   <cfif arguments.UCase IS "Yes">
		<cfset charList = listappend(charlist, alphaUcase, "|")>
	   </cfif>
	 </cfcase>
	
	 <cfcase value="alphanumeric">
	  <cfset charlist = "#alphaLcase#|#numeric#">
	   <cfif arguments.UCase IS "Yes">
		<cfset charList = listappend(charlist, alphaUcase, "|")>
	   </cfif>  
	 </cfcase>
	 
	 <cfcase value="numeric">
	  <cfset charlist = numeric>
	 </cfcase>
	  
	 <cfdefaultcase><cfthrow detail="Valid values of the attribute <b>CharSet</b> are Alpha, AlphaNumeric, and Numeric"> </cfdefaultcase> 
	</cfswitch>
	
	<cfloop from="1" to="#arguments.Length#" index="i">
	 <cfset ThisNum = RandRange(1,listlen(charlist, "|"))>
	 <cfset ThisChar = ListGetAt(Charlist, ThisNum, "|")>
	 <cfset ThisPass = ListAppend(ThisPass, ThisChar, " ")>
	</cfloop>
	
	<cfreturn replace(ThisPass," ","","ALL") />
</cffunction>


</cfcomponent>