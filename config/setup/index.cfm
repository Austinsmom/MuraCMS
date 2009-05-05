<!--- if renderSetup is not found or is false then do not render --->
<cfif NOT isDefined( "renderSetup" ) OR NOT renderSetup>
	<cfabort />
</cfif>

<!--- settings --->
<cfset message = "" />
<!--- get settings path --->
<cfset settingsPath = "#getDirectoryFromPath( getCurrentTemplatePath() )#../settings.ini.cfm" />
<!--- get current file --->
<cfset currentFile = getFileFromPath( getCurrentTemplatePath() ) />
<cfset webRoot = replaceNoCase( CGI.script_name, currentFile, "" ) />
<!--- take out setup folder from webroot --->
<cfset webRoot = replaceNoCase( webRoot, "default/", "" ) />
<!--- clean up the web root and remove the last / --->
<cfset webRoot = mid( webRoot, 1, len( webRoot )-1 ) />

<cfparam name="FORM.fieldnames" default="" />
<cfparam name="FORM.dbType" default="#getProfileString( settingsPath, "production", "dbtype" )#" />
<cfparam name="FORM.production_port" default="#cgi.server_port#" />
<cfparam name="FORM.production_datasource" default="#getProfileString( settingsPath, "production", "datasource" )#" />
<cfparam name="FORM.production_dbusername" default="#getProfileString( settingsPath, "production", "dbusername" )#" />
<cfparam name="FORM.production_dbpassword" default="#getProfileString( settingsPath, "production", "dbpassword" )#" />
<cfparam name="FORM.production_adminemail" default="#getProfileString( settingsPath, "production", "adminemail" )#" />
<cfparam name="FORM.production_mailserverip" default="#getProfileString( settingsPath, "production", "mailserverip" )#" />
<cfparam name="FORM.production_mailserverpopport" default="#getProfileString( settingsPath, "production", "mailserverpopport" )#" />
<cfparam name="FORM.production_mailserverusername" default="#getProfileString( settingsPath, "production", "mailserverusername" )#" />
<cfparam name="FORM.production_mailserverpassword" default="#getProfileString( settingsPath, "production", "mailserverpassword" )#" />
<cfparam name="FORM.production_mailserversmtpport" default="#getProfileString( settingsPath, "production", "mailserversmtpport" )#" />
<cfparam name="FORM.production_mailservertls" default="#getProfileString( settingsPath, "production", "mailservertls" )#" />
<cfparam name="FORM.production_mailserverssl" default="#getProfileString( settingsPath, "production", "mailserverssl" )#" />
<!--- this is a checkbox so we need to review what has been passed in and work accordingly --->
<cfif isDefined( "FORM.production_usedefaultsmtpserver" ) AND FORM.production_usedefaultsmtpserver AND getProfileString( settingsPath, "production", "usedefaultsmtpserver" )>
	<cfparam name="FORM.production_usedefaultsmtpserver" default="#getProfileString( settingsPath, "production", "usedefaultsmtpserver" )#" />
<cfelse>
	<cfparam name="FORM.production_usedefaultsmtpserver" default="0" />
</cfif>

<!--- this is a list of optional form elements that may not show up in the FORM.fieldnames list. to ensure they are there we simple ammend them in --->
<cfset optionalFormElements = "production_usedefaultsmtpserver" />
<cfloop list="#optionalFormElements#" index="optionalFormElement">
	<cfif NOT listFindNoCase( FORM.fieldnames, optionalFormElement )>
		<cfset FORM.fieldnames = listAppend( FORM.fieldnames, optionalFormElement ) />
	</cfif>
</cfloop>

<cfset assetpath = getProfileString( settingsPath, "production", "assetpath" ) />
<cfif len( webRoot ) AND left( trim( assetpath ), len( webRoot ) ) IS NOT webRoot>
	<cfset assetpath = "#webRoot##assetpath#" />
</cfif>
<cfparam name="FORM.production_assetpath" default="#assetpath#" />

<cfset context = getProfileString( settingsPath, "production", "context" ) />
<cfif len( webRoot ) AND left( trim( context ), len( webRoot ) ) IS NOT webRoot>
	<cfset context = "#webRoot##context#" />
</cfif>
<cfparam name="FORM.production_context" default="#context#" />

<!--- state we are done --->
<cfif isDefined( "FORM.#session.setupSubmitButtonComplete#" )>
	<!--- state we are done --->
	<!---
	<cfset setProfileString( settingsPath, "settings", "installed", 1 ) />
	
	<!--- clean ini since it removes cf tags --->
	<cfset cleanIni( settingsPath ) />
	--->
	<!--- cflocate to the admin --->
	<cflocation url="#webRoot#/admin/index.cfm?appreload" />
</cfif>

<!--- run save process --->
<cfif isDefined( "FORM.#session.setupSubmitButton#" )>
	<!--- save settings --->
	<cfset validSections = "production,settings" />
	
	<!--- ************************ --->
	<!--- STEP 1 ---> 
	<!--- ************************ --->
	<!--- check datasource --->
	<cfset errorType = "" />
	<cfset dbCreated = false />
	<cftry>
		<!--- try to run a basic query --->
		<cfquery name="qry" datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
			SELECT COUNT( contentid )
			FROM
				tcontent
		</cfquery>
		<!--- state that the db is already created --->
		<cfset dbCreated = true />
		<!--- purposly pose an error since the user decided to try and build the database --->
		<!---
		<cfif isDefined( "FORM.createDatabase" )>
			<cfset errorType = "database" />
		</cfif>
		--->
		<cfcatch type="database">
			<!--- combine the message and detail so we can check against the both as the CFML engines do not contain similar structures of information --->
			<cfset msg = cfcatch.message & cfcatch.detail />
			
			<!--- check to see if the db is there --->
			<cfif FindNoCase( "tcontent", msg )>
				<cfset errorType = "database" />
			</cfif>
			<!--- check to see if it's a datasource error --->
			<cfif REFindNoCase( "datasource (.*?) doesn't exist", msg )
				OR REFindNoCase( "can't connect to datasource (.*?)", msg )
				OR FindNoCase( "Login failed", msg )
				OR FindNoCase( "Access denied", msg )>
				<cfset errorType = "datasource" />
			</cfif>
			<!--- check to see if it's a broken pipe error --->
			<cfif FindNoCase( "broken pipe", msg )>
				<cfset errorType = "brokenpipe" />
			</cfif>
		</cfcatch>
	</cftry>

	<!--- ************************ --->
	<!--- STEP 2 ---> 
	<!--- MESSAGE STEPS --->
	<!--- CREATE DATABASE STEPS --->
	<!--- ************************ --->
	<!--- generate message --->
	<cfswitch expression="#errorType#">
		
		<!--- datasource --->
		<cfcase value="datasource">
			<cfset message = "<strong>Error:</strong> Either the datasource was not provided, its username/password was incorrect, database permissions were denied for the provided username or the database does not exist" />
		</cfcase>
		
		<!--- database --->
		<cfcase value="database">
			
			<cfset message = "<strong>Error:</strong> There was an issue connecting to the database. The database or database tables might not exist." />
			
			<!--- if it is asked to create the database then do so --->
			<cfif NOT dbCreated AND FORM.dbType IS NOT "">
				<!--- try to create the database --->
				<cftry>
					<!--- get selected DB type --->
					<cffile action="read" file="#getDirectoryFromPath( getCurrentTemplatePath() )#/db/#FORM.dbType#.sql" variable="sql" />
					<!---
					<cfsavecontent variable="sql">
	                	<cfinclude template="db/#FORM.dbType#.sql">
	            	</cfsavecontent>
					--->
					<!--- we adjust the sql to work with a certain parser for later use to help build out an array --->
					<cfswitch expression="#FORM.dbType#">
					
						<cfcase value="mssql">
							<!--- if we are working with a SQL db we go ahead and swap out the GO with ; so we can loop over each sql even --->
							<cfset sql = REReplaceNoCase( sql, "\nGO", ";", "ALL") />
						</cfcase>
					
					</cfswitch>
					
					<!--- append needed process stuff --->
	            	<cfset aSql = ListToArray(sql, ';')>
	            
	    			<!--- loop over items --->
		            <cfloop index="x" from="1" to="#arrayLen(aSql) - 1#">
			            <!--- we placed a small check here to skip empty rows --->
			            <cfif len( trim( aSql[x] ) )>
			                <cfquery datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
			                    #keepSingleQuotes(aSql[x])#
			                </cfquery>
		                </cfif>
		            </cfloop>
		            
		            <!--- update the domain to be local to the domain the server is being installed on --->
		            <cfquery datasource="#FORM.production_datasource#" username="#FORM.production_dbusername#" password="#FORM.production_dbpassword#">
						UPDATE 
							tsettings
						SET
							domain = '#cgi.server_name#'
					</cfquery>
		            
		            <!--- reset the error --->
		            <cfset errorType = "" />
		            <!--- set a message --->
					<cfset message = "" />
					<cfcatch>
						<cfset message = "<strong>Error:</strong> There was an issue with creating the database. Check to make sure you are using the right database. If this continues to occur you may just have to run the associated database script manually. You can find it within the /config/setup/db folder of Mura." />
					</cfcatch>
				</cftry>
			</cfif>
			
			<!--- throw a message if the database already exists --->
			<cfif isDefined( "FORM.createDatabase" ) AND dbCreated>
				<cfset message = "<strong>Error:</strong> Database was not created since it already exists" />
			</cfif>
		</cfcase>
		
		<!--- broken pipe --->
		<cfcase value="brokenpipe">
			<cfset message = "<strong>Error:</strong> Looks like the database pipe broke, try again." />
		</cfcase>
		
	</cfswitch>	

	<!--- ************************ --->
	<!--- STEP 3 ---> 
	<!--- ************************ --->
	<!--- save settings --->
	<cfloop list="#FORM.fieldnames#" index="ele">
		<!--- check to see if we are in one of the proper profiles --->
		<cfif listFindNoCase( validSections, listGetAt( ele, 1, "_" ) )>
			<cfset section = listGetAt( ele, 1, "_" ) />
			<cfset entry = mid( ele, len( section )+2 , len( ele )-len( section ) ) />
			
			<!--- set the profile string --->
			<cfset setProfileString( settingsPath, section, entry, FORM[ele] ) />
			
		</cfif>
	</cfloop>
	
	<!--- ************************ --->
	<!--- STEP 6 ---> 
	<!--- ************************ --->
	<!--- custom settings --->
	<!--- usedefaultsmtpserver --->
	<cfif FORM.production_mailserverip IS NOT "" AND FORM.production_mailserverusername IS NOT "">
		<cfset setProfileString( settingsPath, "production", "usedefaultsmtpserver", 0 ) />
	<cfelse>
		<cfset setProfileString( settingsPath, "production", "usedefaultsmtpserver", 1 ) />
	</cfif>
	
	<!--- ************************ --->
	<!--- STEP 5 ---> 
	<!--- ************************ --->
	<!--- clean ini since it removes cf tags --->
	<cfset cleanIni( settingsPath ) />
	
</cfif>

<!--- few minor functions --->
<cffunction name="cleanIni" returntype="void" output="false">
	<cfargument name="iniPath" type="string" required="true" />
	
	<cfset var abort = "" />
	<cfset var settingsFileContent = "" />
	<cfset var newSettingsFileContent = "" />
	
	<!--- read ini --->
	<cffile action="read" file="#arguments.iniPath#" variable="settingsFileContent" />
	
	<!--- rewrite the settings file if necessary --->
	<cfset abort = "<cf" & "abort/>" />
	<!--- check to see if cfabort is in the file --->
	<cfif left( trim( settingsFileContent ), len( abort ) ) IS NOT "<cfabort/>">
		<!--- prepend content --->
		<cfsavecontent variable="newSettingsFileContent">
			<cfoutput>
			#abort##chr(10)##settingsFileContent#
			</cfoutput>
		</cfsavecontent>
		
		<!--- write the settings file back --->
		<cffile action="write" file="#arguments.iniPath#" output="#trim( newSettingsFileContent )#">
	</cfif>
</cffunction>

<cffunction name="keepSingleQuotes" returntype="string" output="false">
	<cfargument name="str">
	<cfreturn preserveSingleQuotes(arguments.str)>
</cffunction>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<cfoutput>
<head>
<title>Mura CMS - Set Up</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="cache control" content="no-cache, no-store, must-revalidate" />
<script src="#webRoot#/admin/js/admin.js" type="text/javascript" language="Javascript"></script>
<link href="#webRoot#/admin/css/admin.css" rel="stylesheet" type="text/css" />
<!--[if IE]>
<link href="#webRoot#/admin/css/ie.css" rel="stylesheet" type="text/css" />
<![endif]-->
<!--[if IE 6]>
<link href="#webRoot#/admin/css/ie6.css" rel="stylesheet" type="text/css" />
<![endif]-->
</head>
</cfoutput>
<body id="cSetUp" >
<div id="header"><h1>Mura CMS</h1></div>
<div id="container">
<div id="navigation" class="sidebar">
<p id="copyright">Version 5.1</p>
</div>
<div id="content">
<h2>Mura Set Up</h2>

<cfoutput>
<cfif len( trim( message ) )><p class="error">#message#</p></cfif>

<form id="frm" action="index.cfm" method="post" onclick="return validateForm();">

<cfif isDefined( "FORM.#session.setupSubmitButton#" ) AND errorType IS "">
		<div id="installationComplete" class="success">
			<p>Congratulations! Mura is now set up and ready to use.</p>
			<p><strong>Note:</strong> When you are done with setup, it is recommended you remove the "/config/setup" directory to maintain security. Once deleted, all settings can be edited in "/config/settings.ini.cfm" directly.</p>
			<input type="submit" name="#session.setupSubmitButtonComplete#" value="Finish Set Up and Take Me to the Mura Admin" />
		</div>
</cfif>

<h3>Required Settings</h3>
	
	<dl class="twoColumn">
	<dt><a href="" class="tooltip">Datasource (DSN)<span>This the Data Source Name (DSN) created for Mura. This is usually done in the ColdFusion or Railo administrator, or in the control panel of your host if you are installing Mura in a shared environment. Please note that if you are installing Mura in a shared environment, this will likely need to be changed to something other than "muradb" to make sure it is unique to the server.</span></a></dt>
	<dd><input type="text" name="production_datasource" value="#FORM.production_datasource#"></dd>
	
	<dt><a href="" class="tooltip">Database Username<span>This is the same Username supplied to your DSN to allow Mura to connect to your database.</span></a></dt>
	<dd><input type="text" name="production_dbusername" value="#FORM.production_dbusername#"></dd>
	
	<dt><a href="" class="tooltip">Database Password<span>This is the same Password supplied to your DSN to allow Mura to connect to your database.</span></a></dt>
	<dd><input type="text" name="production_dbpassword" value="#FORM.production_dbpassword#"></dd>
	
	<input type="hidden" name="production_assetpath" value="#FORM.production_assetpath#">
	<!---
	<dt><a href="" class="tooltip">Asset Path<span>The URL to where assets uploaded through Mura (images, files, etc) are stored. Can be a domain or root relative path.
<em>Example: http://assets.domain.com, /tasks/sites (no trailing slash)</em></span></a></dt>
	<dd><input type="text" name="production_assetpath" value="#FORM.production_assetpath#"></dd>
	--->
	
	<input type="hidden" name="production_context" value="#FORM.production_context#">
	<!---
	<dt><a href="" class="tooltip">Context<span>If you are installing Mura into a sub-directory, you will need to set the context to that directory.
<em>Example: /nameofdirectory</em> (Note there is no trailing slash)</span></a></dt>
	<dd><input type="text" name="production_context" value="#FORM.production_context#"></dd>
	--->
	
	<!--- port --->
	<input type="hidden" name="production_port" value="<cfif cgi.server_port IS "" AND FORM.production_port IS "">80<cfelse>#FORM.production_port#</cfif>">
	
	<!---
	<dt><a href="" class="tooltip">Create Tables &amp; Schema<span>If you have already set up Mura and are just updating settings here, uncheck this box</span></a></dt>
	<dd><input type="checkbox" name="createDatabase" value="Yes" <cfif isDefined( "FORM.createDatabase" ) AND FORM.createDatabase>checked</cfif>>
	--->
	
	<dt><a href="" class="tooltip">Database<span>Please select a database from the list of supported databases</span></a></dt>
	<dd><select name="dbType">
		<option value="">-- Select your Database Type --</option>
		<option value="mysql" <cfif FORM.dbType IS "mysql">selected</cfif>>MySQL</option>
		<option value="mssql" <cfif FORM.dbType IS "mssql">selected</cfif>>MSSQL</option>
		<option value="oracle" <cfif FORM.dbType IS "oracle">selected</cfif>>Oracle</option>
		<option value="h2" <cfif FORM.dbType IS "h2">selected</cfif>>H2</option>
	</select>
	</dd>
	</dl>
	
<h3>Optional Settings</h3>
<p>By default, Mura is set to use the mail server specified in your application server. If you would like to override this setting to use a specific mail server and mail account, complete the settings below.</p>
	<dl class="twoColumn">
	<dt><a href="" class="tooltip">Admin Email Address<span>The email address used by Mura to send global system emails. Example: user@domain.com.</span></a></dt>
	<dd><input type="text" name="production_adminemail" value="#FORM.production_adminemail#"></dd>
	
	<dt><a href="" class="tooltip">Mail Server<span><strong>The Mail Server used by Mura to send global system emails. Example: mail.domain.com, 278.23.45.697.</span></a></dt>
	<dd><input type="text" name="production_mailserverip" value="#FORM.production_mailserverip#"></dd>
	
	<dt><a href="" class="tooltip">Mail Server Username<span>This is the username used to log into or send emails from the Admin Email account. This may or may not be the same as Admin Email Address.</span></a></dt>
	<dd><input type="text" name="production_mailserverusername" value="#FORM.production_mailserverusername#"></dd>
	
	<dt><a href="" class="tooltip">Mail Server Password<span>The password used to log into the Admin Email account.</span></a></dt>
	<dd><input type="text" name="production_mailserverpassword" value="#FORM.production_mailserverpassword#"></dd>
	
	<dt><a href="" class="tooltip">Mail Server SMTP Port<span>Edit this value to override the default, port 25.</span></a></dt>
	<dd><input type="text" name="production_mailserversmtpport" value="#FORM.production_mailserversmtpport#"></dd>
	
	<dt><a href="" class="tooltip">Mail Server POP Port<span>Edit this value to override the default, port 110.</span></a></dt>
	<dd><input type="text" name="production_mailserverpopport" value="#FORM.production_mailserverpopport#"></dd>
	
	<dt><a href="" class="tooltip">Use TLS<span>Transport Layer Security: Used by some mail providers (Google, for example) to securely send/receive email.</span></a></dt>
	<dd><select name="production_mailservertls" value="#FORM.production_mailservertls#">				<option value="false" <cfif not form.production_mailservertls>selected</cfif>>No</option>
	<option value="true" <cfif form.production_mailservertls>selected</cfif>>Yes</option>
	</select>
	</dd>
	
	<dt><a href="" class="tooltip">Use SSL<span>Secure Socket Layer: Another method used to securely send/receive email.</span></a></dt>
	<dd><select name="production_mailserverssl" value="#FORM.production_mailserverssl#">				<option value="false" <cfif not form.production_mailserverssl>selected</cfif>>No</option>
	<option value="true" <cfif form.production_mailserverssl>selected</cfif>>Yes</option>
	</select>
	</dd>
	</dl>

	<input type="submit" name="#session.setupSubmitButton#" value="Save Settings" />
</form>
</cfoutput>

<p>If you are setting up a Staging <em>and</em> Production type of configuration, you'll need to create the Staging set up manually in "/config/settings.ini.cfm"</p>

</div></div>
<script type="text/javascript" language="javascript">
document.forms[0].elements[0].focus();
</script>

</body>
</html>