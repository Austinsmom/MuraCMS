<cfoutput>

	<!--- Header --->
	<cfinclude template="dsp_users_header.cfm" />

	<!--- TAB NAV --->
	<cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(rc.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>

		<h2>#rc.$.rbKey('user.users')#</h2>

		<ul class="nav nav-tabs">
			<li<cfif rc.ispublic eq 1> class="active"</cfif>>
				<a href="#buildURL(action='cusers.listusers', querystring='siteid=#URLEncodedFormat(rc.siteid)#&ispublic=1&unassigned=#rc.unassigned#')#">
					#rc.$.rbKey('user.sitemembers')#
				</a>
			</li>
			<li<cfif rc.ispublic eq 0> class="active"</cfif>>
				<a href="#buildURL(action='cusers.listusers', querystring='siteid=#URLEncodedFormat(rc.siteid)#&ispublic=0&unassigned=#rc.unassigned#')#">
					#rc.$.rbKey('user.systemusers')#
				</a>
			</li>
		</ul>
	<cfelse>
		<h2>#rc.$.rbKey('user.sitemembers')#</h2>
	</cfif>

	<!--- FILTERS --->
		<div class="well btn-group">
			<a class="btn" href="#buildURL(action='cusers.listusers', querystring='siteid=#URLEncodedFormat(rc.siteid)#&ispublic=#rc.ispublic#&unassigned=#rc.unassignedlink#')#">
				<i class="icon-filter"></i> 
				<cfif rc.unassigned EQ 0>
					#rc.$.rbKey('user.viewunassignedonly')#
				<cfelse>
					#rc.$.rbKey('user.viewall')#
				</cfif>
			</a>

			<a class="btn" href="#buildURL(action='cusers.download', querystring='siteid=#URLEncodedFormat(rc.siteid)#&ispublic=#rc.ispublic#&unassigned=#rc.unassigned#')#">
				<i class="icon-cloud-download"></i> 
				#rc.$.rbKey('user.downloadcsv')#
			</a>
		</div>

	<!--- BODY --->
		<cfif rc.rsUsers.recordcount>
			<table id="tbl-users" class="table table-striped table-condensed table-bordered mura-table-grid">
				<thead>
					<tr>
						<th>
							&nbsp;
						</th>
						<th class="var-width">
							#rc.$.rbKey('user.user')#
						</th>
						<th>
							#rc.$.rbKey('user.email')#
						</th>
						<th>
							#rc.$.rbKey('user.datelastupdate')#
						</th>
						<th>
							#rc.$.rbKey('user.timelastupdate')#
						</th>
						<th>
							#rc.$.rbKey('user.lastupdatedby')#
						</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<!--- RECORDS --->
					<cfloop condition="rc.itUsers.hasNext()">
						<cfsilent>
							<cfscript>
								local.user = rc.itUsers.next();
							</cfscript>
						</cfsilent>
						<tr>
							<!--- Icons --->
							<td class="actions">
								<ul>
									<cfif ListFindNoCase(rc.listUnassignedUsers, local.user.getValue('userid'))>
										<li><a rel="tooltip" title="Unassigned"><i class="icon-exclamation"></i></a></li>
									</cfif>
									<cfif local.user.getValue('s2') EQ 1>
										<li><a rel="tooltip" title="Super User"><i class="icon-bolt"></i></a></li>
									</cfif>
								</ul>
							</td>
							<!--- Last Name, First Name --->
							<td class="var-width">
								<a href="#buildURL(action='cusers.edituser', querystring='userid=#local.user.getValue('userid')#&siteid=#rc.siteid#')#">
									#HTMLEditFormat(local.user.getValue('lname'))#, #HTMLEditFormat(local.user.getValue('fname'))#
								</a>
							</td>
							<!--- Email --->
							<td>
								<cfif Len(local.user.getValue('email'))>
									<a href="mailto:#URLEncodedFormat(local.user.getValue('email'))#">
										#HTMLEditFormat(local.user.getValue('email'))#
									</a>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<!--- Date Lastupdate --->
							<td>
								#LSDateFormat(local.user.getValue('lastupdate'), session.dateKeyFormat)#
							</td>
							<!--- Time Lastupdate --->
							<td>
								#LSTimeFormat(local.user.getValue('lastupdate'), 'short')#
							</td>
							<!--- Last Update By --->
							<td>
								#HTMLEditFormat(local.user.getValue('lastupdateby'))#
							</td>
							<!--- Actions --->
							<td class="actions">
								<ul>
									<li>
										<a href="#buildURL(action='cusers.edituser', querystring='userid=#local.user.getValue('userid')#&siteid=#rc.siteid#')#" rel="tooltip" title="#rc.$.rbKey('user.edit')#">
											<i class="icon-pencil"></i>
										</a>
									</li>

									<cfif local.user.getValue('perm') eq 0>
										<li>
											<a href="#buildURL(action='cusers.update', querystring='action=delete&userid=#local.user.getValue('userid')#&siteid=#rc.siteid#&type=1')#" onclick="return confirmDialog('Delete the #jsStringFormat("'#local.user.getValue('groupname')#'")# User Group?',this.href)" rel="tooltip" title="#rc.$.rbKey('user.delete')#">
												<i class="icon-remove-sign"></i>
											</a>
										</li>
									<cfelse>
										<li class="disabled">
											<i class="icon-remove-sign"></i>
										</li>
									</cfif>
								</ul>
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		<cfelse>
			<div class="alert alert-info">
				#rc.$.rbKey('user.nousers')#
			</div>
		</cfif>

</cfoutput>