
<cfset $=application.serviceFactory.getBean('$').init(session.siteID)>
<cfif isDefined('url.userid')>
	<cfset rc.userBean=$.getBean('user').loadBy(userID=rc.userID,siteID=rc.siteID)>
<cfelse>
	<cfset rc.contentBean=$.getBean('content').loadBy(contentHistID=rc.contentHistID)>
</cfif>

<cfif not (isDefined('rc.fileID') and len(rc.fileID))>
	<cfset rc.rsfileAttributes=rc.contentBean.getExtendedData().getAttributesByType('File')>
	<cfset rc.fileID=listAppend(
				valueList(rc.rsfileAttributes.attributeValue),
				rc.contentBean.getFileID()
			)>
</cfif>

<cfif isNumeric($.siteConfig('smallImageHeight')) and isNumeric($.siteConfig('smallImageWidth'))>
	<cfset rc.smallImageRatio=$.siteConfig('smallImageWidth')/$.siteConfig('smallImageHeight')>
<cfelse>
	<cfset rc.smallImageRatio=''>
</cfif>

<cfif isNumeric($.siteConfig('mediumImageHeight')) and isNumeric($.siteConfig('mediumImageWidth'))>
	<cfset rc.mediumImageRatio=$.siteConfig('mediumImageWidth')/$.siteConfig('mediumImageHeight')>
<cfelse>
	<cfset rc.mediumImageRatio=''>
</cfif>

<cfif isNumeric($.siteConfig('largeImageHeight')) and isNumeric($.siteConfig('largeImageWidth'))>
	<cfset rc.largeImageRatio=$.siteConfig('largeImageWidth')/$.siteConfig('largeImageHeight')>
<cfelse>
	<cfset rc.largeImageRatio=''>
</cfif>

<cfsavecontent variable="rc.headertext">
<cfoutput>
<script src="#$.globalConfig('context')#/admin/assets/js/jquery/jquery.Jcrop.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="#$.globalConfig('context')#/admin/assets/css/jquery/jquery.Jcrop.min.css" type="text/css" />
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#rc.headertext#">

<cfoutput>
<h1>Image Details</h1>

<cfinclude template="dsp_secondary_menu.cfm">

<cfif rc.compactDisplay neq "true" and isDefined('rc.contentBean')>
	#application.contentRenderer.dspZoom(rc.contentBean.getCrumbArray(),rc.contentBean.getFileExt())#
</cfif>

<div id="image-details" class="form-horizontal">
<cfif len(rc.fileID)>
	<cfloop list="#rc.fileID#" index="f">	
		<cfset rc.sourceImage=$.getURLForImage(fileID=f,size='source')>
		<cfif len(rc.sourceImage)>		
			<cfset rc.rsMeta=$.getBean('fileManager').readMeta(fileID=f)>
			<h2><i class="icon-picture"></i> #HTMLEditFormat(rc.rsMeta.filename)#</h2>
			<cfloop list="Small,Medium,Large" index="s">
				<div class="control-group divide">
					<label class="control-label">#s# (80x80) <a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.editSite&siteid=#session.siteid###tabImages"><i class="icon-edit"></i></a></label>
					<div class="controls">
						<div id="#lcase(s)##f#btns" class="btn-group">
							<button type="button" class="btn btn-small cropper-reset" data-fileid="#f#" data-size="#lcase(s)#"><i class="icon-refresh"></i> Reset</button>
							<button type="button" class="btn btn-small cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-ratio="#evaluate('rc.#s#ImageRatio')#" data-size="#lcase(s)#"><i class="icon-screenshot"></i> Re-Crop</button>
						</div>
					</div>
					<img src="./assets/images/progress_bar.gif" style="display:none">
					<img id="#lcase(s)##f#" src="#$.getURLForImage(fileID=f,size=lcase(s))#?cacheID=#createUUID()#"/>
				</div>
			</cfloop>
			<cfset imageSizes=application.settingsManager.getSite(rc.siteid).getCustomImageSizeIterator()>
			<cfloop condition="imageSizes.hasNext()">
				<cfset customImage=imageSizes.next()>
				<cfif isNumeric(customImage.getHeight()) and isNumeric(customImage.getWidth())>
					<cfset rc.customImageRatio=customImage.getWidth()/customImage.getHeight()>
				<cfelse>
					<cfset rc.customImageRatio=''>
				</cfif>
				<div class="control-group divide">
					<label class="control-label">#HTMLEditFormat(customImage.getName())# (80x80) <a href="#application.configBean.getContext()#/admin/index.cfm?muraAction=cSettings.editSite&siteid=#session.siteid###tabImages"><i class="icon-edit"></i></a></label>
					<div class="controls">
						<div id="#lcase(customImage.getName())##f#btns" class="btn-group">
							<button type="button" class="btn btn-small cropper-reset" data-fileid="#f#" data-size="#lcase(customImage.getName())#"><i class="icon-refresh"></i> Reset</button>
							<button type="button" class="btn btn-small cropper" data-fileid="#f#" data-src="#rc.sourceImage#" data-filename="#rc.rsMeta.filename#" data-ratio="#rc.customImageRatio#" data-size="#lcase(customImage.getName())#"><i class="icon-screenshot"></i> Re-Crop</button>
						</div>
					</div>
					<img src="./assets/images/progress_bar.gif" style="display:none">
					<img id="#lcase(customImage.getName())##f#" src="#$.getURLForImage(fileID=f,size=lcase(customImage.getName()))#?cacheID=#createUUID()#"/>
				</div>
			</cfloop>
		</cfif>
	</cfloop>

	<!-- Hidden dialog 
   	<div style="display:none;" id="jc-container" >
		<div class="jc-dialog">
		   	<img id="jc-source-image"/>
		</div>
    </div>
    -->
  
    <script>
    var currentFileID='';
    var currentCoords='';
	var currentSize='';

	function reloadImg(id) {
	   var obj = document.getElementById(id);
	   var src = obj.src;
	   var pos = src.indexOf('?');
	   if (pos >= 0) {
	      src = src.substr(0, pos);
	   }
	   var date = new Date();
	   obj.src = src + '?v=' + date.getTime();
	   return false;
	}

	function resizeImg(id,w,h) {
	   $('##'+ id).css({'height':h,'width':w});
	   return false;
	}

    function saveCoords(c){currentCoords=c};

    function applyCropping(){
    	$('##applyingCoords').show();
    	$('##cropper .btn').hide();
 		
 		//location.href='./index.cfm?muraAction=carch.cropimage&fileid=' + currentFileID + '&size=' + currentSize + '&x=' + currentCoords.x + '&y=' + currentCoords.y + '&width=' + currentCoords.w + '&height=' + currentCoords.h + '&siteid=' + siteid;

 		if(typeof(currentCoords) == 'object'){
	    	jQuery.get('./index.cfm?muraAction=carch.cropimage&fileid=' + currentFileID + '&size=' + currentSize + '&x=' + currentCoords.x + '&y=' + currentCoords.y + '&width=' + currentCoords.w + '&height=' + currentCoords.h + '&siteid=' + siteid,
								function(data) {	
									//alert(JSON.stringify(data));
									reloadImg(currentSize + currentFileID);
									resizeImg(currentSize + currentFileID,data.width,data.height);
									$('##cropper').remove()
								}
							);
		} else {
			$('##cropper').remove();
		}		
    }

    $('.cropper-reset').click(
    	function(){

    		currentFileID=$(this).attr('data-fileid');
			currentSize=$(this).attr('data-size')
			//alert(currentSize + currentFileID);

    		$('##'  + currentSize + currentFileID + 'btns .btn').hide();
    		$('##'  + currentSize + currentFileID + 'btns img').show();

    		//location.href='./index.cfm?muraAction=carch.cropimage&fileid=' + currentFileID + '&size=' + currentSize + '&siteid=' + siteid;

    		jQuery.get('./index.cfm?muraAction=carch.cropimage&fileid=' + currentFileID + '&size=' + currentSize + '&siteid=' + siteid,
							function(data) {	
								//alert(JSON.stringify(data));
								reloadImg(currentSize + currentFileID);
								resizeImg(currentSize + currentFileID,data.width,data.height);
								$('##'  + currentSize + currentFileID + 'btns .btn').show();
    							$('##'  + currentSize + currentFileID + 'btns img').hide();
							}
						);		

    		
    });
	

    $('.cropper').click(
    	function(){

    		currentFileID=$(this).attr('data-fileid');
			currentSize=$(this).attr('data-size');
			currentCoords='';

    		var jcrop_api; 
    		var $dialogHTML='<div id="cropper"><div class="jc-dialog">';
    			$dialogHTML+='<img id="crop-target" src="' + $(this).attr('data-src') + '" /> '; 
    			$dialogHTML+='<br/><input type="hidden" name="coords" value="" id="coords">'; 
    			$dialogHTML+='<input class="btn" type="button" value="Cancel" onclick="$(\'##cropper\').remove();">';
    			$dialogHTML+='<input class="btn" type="button"id="applyCoords" value="Apply Cropping" onclick="applyCropping();">';
    			$dialogHTML+='<img id="applyingCoords" src="./assets/images/progress_bar.gif" style="display:none">';
    			$dialogHTML+='</div></div>';

	        var $dialog = $($dialogHTML);
	        var title=$(this).attr('data-filename');
	        var scaleby=$(this).attr('data-scaleby');
	        var aspectRatio=$(this).attr('data-ratio');
	        $dialog.find('##crop-target').Jcrop({ boxHeight:600,boxWidth:600,aspectRatio:aspectRatio,onSelect:saveCoords,onChange:saveCoords},function(){
		        jcrop_api = this;
		        $dialog.dialog({
		            modal: true,
		            title: title,
		            close: function(){ $dialog.remove(); },
		            width: jcrop_api.getWidgetSize()[0]+4,
		            resizable: false,
		        });
    		});
    });
	</script>
	
    <!-- /Hidden dialog -->
</div>
<cfelse>
	<p class="notice">This content does not have any image attached to it.</p>
</cfif>
</cfoutput>