$(function(){
  initDatePicker();
  initReportFinalization();
});

function initDatePicker(){
  $(".datepicker").datepicker({format: 'yyyy-mm-dd'});
}

function initReportFinalization(){

  $("form.report").submit(function(){
    var form = $(this);
    var confirmation = form.find("input[id=confirm]");
    if(confirmation.is(':checked')){
      var resp= confirm("Are you sure? Checking Finalize and Confirm will prevent you from make any future changes to this report.");
      if (resp===false){
        return false;
      }
    }
  });

}
