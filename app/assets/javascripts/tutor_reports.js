$(function(){
  initreportfinalization();
});

function initreportfinalization(){

  $("form.report").submit(function(){
    var form = $(this);
    var confirmation = form.find("input[id=confirm]");
    if(confirmation.is(':checked')){
      var resp= confirm("are you sure? checking finalize and confirm will prevent you from make any future changes to this report.");
      if (resp===false){
        return false;
      }
    }
  });

}
