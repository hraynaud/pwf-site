(function init(){
  $(function() {
    initJQAddFields();
    initJQRemoveFields();
    initJQGradeScaleChanged();
    initGradeValueConstraints();
  })


  function initJQRemoveFields(){
    $('form').on('click', '.remove_fields', function(event) {
      $(this).parents('tr').hide();
      $(this).parents('tr').find('input[type=hidden]').val('1');
      return event.preventDefault();
    });
  }

  function initJQAddFields(){

    function add_row(row){
      $('#grades_table tbody').append(row)
      return false;
    }

    function replaceDummyId($addLink){
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($addLink.data('id'), 'g');
      return $addLink.data('fields').replace(regexp, time);
    }

    $('form').on('click', '.add_fields', function(event) {
      var new_row = replaceDummyId($(this));
      add_row(new_row);
      return event.preventDefault();
    });
  }

  function initGradeValueConstraints(){
    var validations = $("#grade_values").data("validations")
    var constraints = validations[0];
    var custError;
    if(validations[1] !== undefined){
      custError = validations[1].message;
    }
    debugger
    custError && $( '#grade_values' ).data("error-message", custError) ;
    $( '#grade_values' ).parsley( 'addConstraint', constraints ); 
  }

  function initJQGradeScaleChanged(){
    function confirmFormatChange(){
      var row_count, change_format
      row_count = $('#grades_table > tbody >tr:visible').length > 0
      return row_count>0 ? confirm("Are you sure? Changing the grade format will delelete your existing grades") : true;
    }

    var $grade_format = $("#grade_scale");

    $grade_format.change(function(){
      if(confirmFormatChange()){
        $(".remove_fields").click();
      }
    });
  }

})();
