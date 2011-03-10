<cfoutput>
<cfif not currentChangeset.getIsNew()>
<p class="notice">#application.rbFactory.getKeyValue(session.rb,"sitemanager.content.changesetnotenotify")#: "#currentChangeset.getName()#"</p>
</cfif>
<script>
<cfif not currentChangeset.getIsNew()>
var currentChangesetSelection="#request.contentBean.getChangesetID()#";
var currentChangesetID="#request.contentBean.getChangesetID()#";
<cfelse>
var currentChangesetSelection="";
var currentChangesetID="";
</cfif>

function removeChangesetPrompt(changesetID){
	
	if(currentChangesetID!="" && changesetID!=currentChangesetID){
		jQuery("##removeChangesetContainer").show();
	} else {
		jQuery("##removeChangesetContainer").hide();
		document.getElementById("_removePreviousChangeset").checked=false;
	}
	
	currentChangesetSelection=changesetID;
}

function saveToChangeset(changesetid,siteid,keywords){
	
	var url = 'index.cfm';
	var pars = 'fuseaction=cArch.availablechangesets&compactDisplay=true&siteid=' + siteid  + '&keywords=' + keywords + '&changesetid=' + changesetid +'&cacheid=' + Math.random();
	var d = jQuery('##changesetContainer');
	d.html('<img class="loadProgress" src="images/progress_bar.gif">');
	jQuery.get(url + "?" + pars, 
			function(data) {
			jQuery('##changesetContainer').html(data);
			stripe('stripe');
			});
		
		jQuery("##changesetContainer").dialog({
			resizable: false,
			modal: true,
			buttons: {
				'#JSStringFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.save"))#': function() {
					jQuery(this).dialog('close');
					if(ckContent()){
						document.getElementById('contentForm').changesetID.value=currentChangesetSelection;
						document.getElementById('contentForm').removePreviousChangeset.value=document.getElementById("_removePreviousChangeset").checked;
						submitForm(document.contentForm,'add');
						}
						return false;
					}
			}
		});
	
	
	return false;	
}
</script>
<div style="display:none" title="#HTMLEditFormat(application.rbFactory.getKeyValue(session.rb,"sitemanager.content.assigntochangeset"))#" id="changesetContainer">

</div>
</cfoutput>