$(document).ready(function() {
  $('.dtable').dataTable( {
    "sDom": "<'row'<'span2'l><'span3'f>r>t<'row'<'span5'i>><'row'<'span5'p>>",
    "sPaginationType": "bootstrap",
    "oLanguage": {
      "sLengthMenu": "_MENU_ items"
    },
    "aaSorting": []
  } );

  $.extend( $.fn.dataTableExt.oStdClasses, {
    "sWrapper": "dataTables_wrapper form-inline"
  } );

} );

