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

