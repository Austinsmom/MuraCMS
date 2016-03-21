	<div class="form-group" id="field-{{name}}-container">
		<label class="control-label" for="{{name}}">{{label}}</label>	
		<div class="form-group-select">
			<select class="form-control" type="text" name="{{name}}id" id="field-{{name}}">
				{{#each dataset.options}}
					<option data-isother="{{isother}}" id="field-{{id}}" value="{{id}}" {{#if isselected}}selected='selected'{{/if}}>{{label}}</option>
				{{/each}}
			</select>
		</div>
	</div>

