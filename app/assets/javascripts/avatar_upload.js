$(function(){

  $(".file-chooser-proxy").click(function(){
    $($(this).data("target")).click();
  });

  $( '.file-chooser' ).change( function(e) {
    var form = $(this).parent('form').get(0);
    form.submit();
  })


});
