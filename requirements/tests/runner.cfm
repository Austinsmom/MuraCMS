<cfsetting showdebugoutput="false" >
<cfparam name="url.reporter" default="simple">
<cfif directoryExists(Expandpath("/testbox"))>
    <cfset r = new testbox.system.TestBox( directory={ mapping = "murawrm.requirements.tests.specs", recurse = true } ) >
    <cfoutput>#r.run(reporter=url.reporter)#</cfoutput>
<cfelse>
    Access Restricted.
</cfif>
