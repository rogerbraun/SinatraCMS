$(document).ready(function() {
  var pathname = window.location.pathname.replace("/","");
  $('a[href*="' + pathname + '"]').addClass('active');  

  $("#nav ul ul li").mouseover(function() {
    var img_name = $(this).children("a")[0].pathname.replace("/","");
   $("#sidebar_img").attr("src","img/"+ img_name  +".jpg")   
  });

  $("#nav ul ul li").mouseout(function() {
   $("#sidebar_img").attr("src","img/" + pathname + ".jpg")   

  });

});

sfHover = function() {
  var sfEls = document.getElementById("nav").getElementsByTagName("LI");
  for (var i=0; i<sfEls.length; i++) {
    sfEls[i].onmouseover=function() {
      this.className+=" sfhover";
    }
    sfEls[i].onmouseout=function() {
      this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
    }
  }
}
if (window.attachEvent) window.attachEvent("onload", sfHover);
