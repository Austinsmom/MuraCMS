<script id="field-checkbox" type="text/x-handlebars-template">
	<div class="form-group" id="field-{{name}}-container">
		<div class="form-group-radio">
			<label class="control-label">
			{{displayName}}
			</label>
			{{#each options}}
				<label class="control-label">	
				<input class="form-control" type="checkbox" name="{{../name}}" id="field-{{id}}" value="{{id}}" />
				{{label}}</label>
			{{/each}}
		</div>
	</div>
</script>