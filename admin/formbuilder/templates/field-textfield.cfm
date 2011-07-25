<cfoutput><span>
		<div class="meld-tb-form">
			<div class="meld-tb-header">
				<h3>#mmRBF.getKey('field_textfield')#: <span id="meld-tb-form-label">bob</span></h3>
				<ul class="right">
					<li><div class="ui-button" id="button-trash" title="#mmRBF.getKey('delete')#"><span class="ui-icon ui-icon-closethick"></span></div></li>
				</ul>
			</div>
			<div class="columns clearfix">
				<div class="col2 wide bordered">
					<ul class="template-form">
						<li>
							<label for="field_label">#mmRBF.getKey('field_label')#</label>
							<input class="text medium tb-label" type="text" name="label" value="" maxlength="50" data-required='true' />
						</li>
						<li>
							<label for="field_value">#mmRBF.getKey('field_value')#</label>
							<input class="text long" type="text" name="value" value="" maxlength="250" />
						</li>
					</ul>
				</div>
				<div class="col3 right">
					<ul class="template-form">
						<li>
							<label for="field_cssstyle">#mmRBF.getKey('field_cssstyle')#</label>
							<select class="select" name="cssstyle">
								<option value="small">Small</option>
								<option value="medium">Medium</option>
								<option value="large">Large</option>
							</select>
						</li>
					</ul>
				</div>
			</div>
			<div class="columns clearfix topbordered">
				<div class="col2 wide bordered">
					<ul class="template-form">
						<li>
							<label for="field_validatetype">#mmRBF.getKey('field_validatetype')#</label>
							<select class="select" name="validatetype">
								<option value="">#mmRBF.getKey('none')#</option>
								<option value="numeric">#mmRBF.getKey('numeric')#</option>
								<option value="date">#mmRBF.getKey('date')#</option>
								<option value="email">#mmRBF.getKey('email')#</option>
								<option value="regex">#mmRBF.getKey('regex')#</option>
							</select>
						</li>
						<li>
							<label for="field_validateregex">#mmRBF.getKey('field_validateregex')#</label>
							<input class="text long" type="text" name="validateregex" value="" maxlength="250" />
						</li>
						<li>
							<label for="field_validatemessage">#mmRBF.getKey('field_validatemessage')#</label>
							<input class="text long" type="text" name="validatemessage" value="" maxlength="250" />
						</li>
						<li class="checkbox">
							<label for="field_isrequired">
							<input type="checkbox" type="text" name="isrequired" value="1">
							#mmRBF.getKey('field_isrequired')#</label>
						</li>
					</ul>
				</div>
				<div class="col3 right">
					<ul class="template-form">
						<li>
							<label for="field_name">#mmRBF.getKey('field_name')#</label>
							<input id="tb-name" class="text medium disabled" name="name" type="text" value="" maxlength="50" disabled="true" />
						</li>
						<li>
							<label for="field_texttip">#mmRBF.getKey('field_texttip')#</label>
							<input class="text long" type="text" name="texttip" value="" maxlength="250" />
						</li>
					</ul>
				</div>
			</div>
		</div>
	</span>
</cfoutput>