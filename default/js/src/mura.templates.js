mura.templates={};
mura.templates['meta']=function(context){
  if(context.label){
    return "<h3>" + mura.escapeHTML(context.label) + "</h3>";
  } else {
    return '';
  }  
}
mura.templates['text']=function(context){
	context.freetext=context.freetext || '<p>This free text object has not been configured.</p>';
 	var html='<div class="mura-object-meta">' + mura.templates['meta'](context) + '</div>';
 		html+='<div class="mura-object-content">' + context.source + '</div>';
 	return html;
}
mura.templates['socialembed']=function(context){
	context.source=context.source || '<p>This social embed object has not been configured.</p>';
 	var html='<div class="mura-object-meta">' + mura.templates['meta'](context) + '</div>';
 		html+='<div class="mura-object-content">' + context.source + '</div>';
 	return html;
}