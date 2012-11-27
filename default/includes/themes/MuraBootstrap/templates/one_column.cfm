<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<div class="#$.getMBContainerClass()#">
			<div class="#$.getMBRowClass()#">
				<cfinclude template="inc/navbar.cfm">
			</div>
			<div class="#$.getMBRowClass()# content-container">
				<div class="content span12">
					<cfinclude template="inc/breadcrumb.cfm">
					#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
					#$.dspObjects(2)#
				</div>
			</div>
			<div class="row">
				<cfinclude template="inc/footer.cfm">
			</div>
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm">
</cfoutput>