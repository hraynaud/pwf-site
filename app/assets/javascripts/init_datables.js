$(document).ready(function() {
  $('.dtable').dataTable( {
    "sDom": "<'row'<'span4'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "oLanguage": {
      "sLengthMenu": "_MENU_ records per page"
    }
  } );
} );
