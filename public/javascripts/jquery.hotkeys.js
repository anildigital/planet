////
// simple hotkeys plugin.
// 
//   <a href="link" hotkey="a">all</a>
//
//   $.hotkey('a', function() { window.location = 'somewhere' })
//
//   $.hotkeys({
//     'a': function() { window.location = 'somewhere' },
//     'b': function() { alert('something else') }
//   })
//
(function($) {
  $.hotkeys = function(options) {
    for(key in options) $.hotkey(key, options[key])
    return this
  }

  // accepts a function or url
  $.hotkey = function(key, value) {
    $.hotkeys.cache[key.charCodeAt(0) - 32] = value
    return this
  }
  
  $.hotkeys.cache = {}
	})(jQuery)

jQuery(document).ready(function($) {  
  $('a[hotkey]').each(function() {
    $.hotkey($(this).attr('hotkey'), $(this).attr('href'))
  })

  $(document).bind('keydown.hotkey', function(e) {
    // don't hotkey when typing in an input
    if ($(e.target).is(':input')) return
    // no modifiers supported 
    if (e.shiftKey || e.ctrlKey || e.altKey || e.metaKey) return true
    var el = $.hotkeys.cache[e.keyCode]
    if (el) $.isFunction(el) ? el.call(this) : window.location = el
  })

 $.hotkey('s', function() { window.scrollTo(0,0); s = document.getElementById('search');  s.focus(); });

 $.hotkey('h', function(){
	loading_msg = "Loading";
  	href = $("a[rel=prev]").attr("href");
	if (href != undefined) {
	  //$('#notice').css("color","red");
	  $('#notice').html(loading_msg);
	  window.location = href;
	}
	else {
	  href = $("a[rel=prev start]").attr("href");
	  if (href != undefined) {
		//$('#notice').css("color","red");
		$('#notice').html(loading_msg);
	    window.location = href;
	  }
	}
  });

  $.hotkey('l', function(){
	loading_msg = "Loading";
  	href = $("a[rel=next]").attr("href");
	if (href != undefined) {
	 //$('#notice').css("color","red");
	 $('#notice').html(loading_msg);
	  window.location = href;
	}	
  });
 
  step = 0;
  j_typed = false;
  k_typed = false;

  $.hotkey('t', function(){
	window.location = "#top";
	step = 0;
	j_typed = false;
	k_typed = false;
  } );


  $.hotkey('d', function(){
	window.location = "#down";
	step = 0;
	j_typed = false;
	k_typed = false;
  } );

  $.hotkey('j', function() { 
 	
	if(step < (linksArray.length - 1)){
			step = step + 1;
	}
	if( (j_typed == false) && (k_typed == false)){
		step = 0;
	}
	hash = linksArray[step];
	window.location = "#"+ hash;
	
	j_typed = true;
	k_typed = false;
	
	});
	
  $.hotkey('k', function() { 
	
	 if (step != 0) {
		if(step == 1){
			step = step - 1;
		}
		else if (j_typed = true){
			step = step - 1;
		}
	}
	
	hash = linksArray[(step)];
	window.location = "#"+ hash;
	
	k_typed = true;
	j_typed = false;

	});
});
