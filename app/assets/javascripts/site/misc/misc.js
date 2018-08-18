$(function(){
  initdatepicker();
  initChosenSelect()
});

function initdatepicker(){
  $(".datepicker").datepicker({format: 'yyyy-mm-dd'});
}

function initChosenSelect(){
  $(".jqSelect").chosen();
}


//DATATABLES
$(document).ready(function() {
  $.extend( $.fn.dataTableExt.oStdClasses, {
    "sWrapper": "dataTables_wrapper form-inline"
  } );

  $('.dtable').dataTable( {
    "sDom": "<'row'<'span5'fl>>t<'row'<'span5'i>><'row'<'span5'p>>",
    "sPaginationType": "bootstrap",
    "oLanguage": {
      "sLengthMenu": "_MENU_ items"
    },
    "aaSorting": [],
    "iDisplayLength": 10
  } );
} );


//tutor_reports
//
//
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
