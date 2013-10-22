/* This file is part of Mura CMS. 

	Mura CMS is free software: you can redistribute it and/or modify 
	it under the terms of the GNU General Public License as published by 
	the Free Software Foundation, Version 2 of the License. 

	Mura CMS is distributed in the hope that it will be useful, 
	but WITHOUT ANY WARRANTY; without even the implied warranty of 
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
	GNU General Public License for more details. 

	You should have received a copy of the GNU General Public License 
	along with Mura CMS.  If not, see <http://www.gnu.org/licenses/>. 

	Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
	Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.
	
	However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
	or libraries that are released under the GNU Lesser General Public License version 2.1.
	
	In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
	independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
	Mura CMS under the license of your choice, provided that you follow these specific guidelines: 
	
	Your custom code 
	
	• Must not alter any default objects in the Mura CMS database and
	• May not alter the default display of the Mura CMS logo within Mura CMS and
	• Must not alter any files in the following directories.
	
	 /admin/
	 /tasks/
	 /config/
	 /requirements/mura/
	 /Application.cfc
	 /index.cfm
	 /MuraProxy.cfc
	
	You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
	under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
	requires distribution of source code.
	
	For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
	modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
	version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS. */


var commentManager = {
	loadSearch: function(siteid, isNew, values, advSearch) {
		var url = './';
		var pars = 'muraAction=cComments.loadComments&siteid=' + siteid + '&isNew=' + isNew + '&' + values + '&cacheid=' + Math.random();
		
		var d = $('#commentSearch');
		d.html('<div class="load-inline"></div>');
		$('#commentSearch .load-inline').spin(spinnerArgs2);
		$.get(url + "?" + pars, function(data) {
			$('#commentSearch').html(data);
					
			setDatePickers(".mura-custom-datepicker", dtLocale, dtCh);
			
			$('#aAdvancedSearch').click(function(e){
				e.preventDefault();
				$('#advancedSearch').slideToggle('fast');
			});	
			
			if (isNew == 0 && advSearch == true) {
				$('#advancedSearch').show();
				$('#aAdvancedSearch').addClass('active');
			}
			
			setCheckboxTrees();
			
			$('#advancedSearch').find('ul.categories:not(.checkboxTrees)').css("margin-left", "10px");
			
			$('#btnSearch').click(function(e){
				e.preventDefault();
				commentManager.submitSearch();
			});

			$('#frmSearch').submit(function(e){
				e.preventDefault();
				commentManager.submitSearch();
			});

			$('a.sort').click(function(e){
				e.preventDefault();
				commentManager.setSort($(this));
			});
		});
	},

	submitSearch: function(){
		var advSearching = $('#advancedSearch').is(':visible');
		var valueSelector = '#commentSearch input';
		// if doing an advanced search, then serialze all elements
		if (advSearching) {
			valueSelector = '#commentSearch input, #commentSearch select';	
		}
						
		commentManager.loadSearch(siteid, 0, $(valueSelector).serialize(), advSearching);
	},

	setSort: function(k){
		$('#sortBy').val(k.attr('data-sortby'));
		$('#sortDirection').val(k.attr('data-sortdirection'));
		
		commentManager.submitSearch();
	}
}