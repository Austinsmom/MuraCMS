<cfoutput>
	<footer>
		<div class="wrap clearfix">
			<ul class="navUtility">
				<li><a href="#$.createHREF(filename='about-us')#">About Us</a></li>
				<li><a href="#$.createHREF(filename='news')#">News</a></li>
				<li><a href="#$.createHREF(filename='blog')#">Blog</a></li>
				<li><a href="#$.createHREF(filename='mura')#">Mura</a></li>
				<li><a href="#$.createHREF(filename='contact')#">Contact</a></li>
				<li class="last"><a href="./?mobileFormat=true">#$.rbKey("mobile.mobileversion")#</a></li>
			</ul>
			<p>&copy;#year(now())# #HTMLEditFormat($.siteConfig('site'))#</p>
		</div>
	</footer>
	<cfif listFirst(server.coldfusion.productversion) lt 8>
	<cf_CacheOMatic key="globalfooterjs">
	#$.static()
		.include("/js/ie/lte8/")
		.include("/js/ie/DD_roundies.js")
		.renderIncludes("js")#
	</cf_CacheOMatic>
	</cfif>
	<cfinclude template="ie_conditional_includes.cfm" />		
</cfoutput>