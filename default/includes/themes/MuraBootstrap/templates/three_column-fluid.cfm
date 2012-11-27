<cfoutput>
	<cfinclude template="inc/html_head.cfm">
	<body id="#$.getTopID()#" class="#$.createCSSid($.content('menuTitle'))#">
		<div class="container-fluid">
			<div class="row-fluid">
				<cfset navbarContainerClass = 'container-fluid'>
				<cfinclude template="inc/navbar.cfm">
			</div>
      		<div class="row-fluid content-container">
	      		<div class="span3">
	      		    #$.dspObjects(1)#
	      		</div><!--/span3-->
				<div class="span6 content">
					<cfinclude template="inc/breadcrumb.cfm">
					#$.dspBody(body=$.content('body'),pageTitle=$.content('title'),crumbList=0,showMetaImage=1)#
					#$.dspObjects(2)#
		        </div><!--/span6-->
		        <div class="span3">
				    #$.dspObjects(3)#
				</div><!--/span-->
			</div><!--/row-->
			<div class="row-fluid">
				<cfinclude template="inc/footer.cfm">
			</div>		
		</div><!-- /.container -->
	<cfinclude template="inc/html_foot.cfm">
</cfoutput>


