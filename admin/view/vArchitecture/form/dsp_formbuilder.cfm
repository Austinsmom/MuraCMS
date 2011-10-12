﻿<cfoutput>
<script>

	function saveFormBuilder(){
		jQuery("##meld-templatebuilder").templatebuilder('save');
	}

	jQuery(document).ready(function() {
		jQuery("##meld-templatebuilder").templatebuilder();

		jQuery("##bink").click( function() {
			jQuery("##meld-templatebuilder").templatebuilder('bink');
		});

		myDump = function(obj, name, indent, depth, maxdepth) {
				var self = this;
		
			if(!maxdepth)
				maxdepth = 1;
		
			if (depth > maxdepth) {
			     return indent + name + ": <Maximum Depth Reached>\n";
			}
			
			if (typeof obj == "object") {
			     var child = null;
			     var output = indent + name + "\n";
			     indent += "\t";
			     for (var item in obj)
			     {
			           try {
			                  child = obj[item];
			           } catch (e) {
			                  child = "<Unable to Evaluate>";
			           }
			           if (typeof child == "object") {
							  output += myDump(child, item, indent,depth++,maxdepth);
			           } else {
			                  output += indent + item + ": " + child + "\n";
			           }
			     }
			     return output;
			} else {
			     return obj;
			}
		}

	});
</script>
	<div id="meld-templatebuilder" data-url="#$.globalConfig('context')#/admin/index.cfm">
		<div class="meld-tb-menu">
			<ul>
			<li><div class="ui-button button-field" id="button-section" data-object="section-section" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.section.tooltip')#"><span class="ui-button-text ui-icon-formfield-section">#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.section')#</span></div></li>
			<li class="spacer"></li>
			<li><div class="ui-button button-field" id="button-textfield" data-object="field-textfield" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.textfield.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-textfield"></span></div></li>
			<li><div class="ui-button button-field" id="button-textarea" data-object="field-textarea" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.textarea.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-textarea"></span></div></li>
			<li><div class="ui-button button-field" id="button-radio" data-object="field-radio" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.radio.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-radiobox"></span></div></li>
			<li><div class="ui-button button-field" id="button-checkbox" data-object="field-checkbox" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.checkbox.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-checkbox"></span></div></li>
			<li><div class="ui-button button-field" id="button-dropdown" data-object="field-dropdown" title="#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.dropdown.tooltip')#"><span class="ui-icon ui-icon-formfield ui-icon-formfield-select"></span></div></li>
			</ul>
		</div>
		<div id="meld-tb-form" class="clearfix">
			<div id="meld-tb-form-fields">
				<div id="meld-tb-fields-empty" class="notice">#application.rbFactory.getKeyValue(session.rb,'formbuilder.fields.empty')#</div>
				<ul id="meld-tb-fields">
				</ul>
			</div>
			<div id="meld-tb-fields-settings">	
				<div id="meld-tb-field-form" class="meld-tb-data-form">
					<div id="meld-tb-field-empty" class="notice">#application.rbFactory.getKeyValue(session.rb,'formbuilder.field.empty')#</div>
					<div id="meld-tb-field">
					</div>
				</div>
				<div id="meld-tb-dataset-form" class="meld-tb-data-form">
				</div>
				<div id="meld-tb-grid">
				</div>
			</div>
		</div>

	</div>	
	<textarea id="meld-formdata" name="body">#request.contentBean.getBody()#</textarea>
	
</cfoutput>
