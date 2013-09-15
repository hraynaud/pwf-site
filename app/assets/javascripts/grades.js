(function init(){
  $(function() {
    initJQAddFields();
    initJQRemoveFields();
    initJQGradeScaleChanged();
    initParselyValidations()
    $( '#report_card_form' ).parsley('validate');
  })

  function initParselyValidations(){
    $('.grade_value').each(function(index){
      var fieldId = "#" + $(this).attr("id")
      applyFieldValidations(extractValidations(),fieldId);
    })
  }

  function removeFromValidation(field){
    $( '#report_card_form' ).parsley('destroy');
    $('#report_card_form').parsley( 'removeItem', field ) 
    $( '#report_card_form' ).parsley('validate');
  }

  function initJQRemoveFields(){
    $('form').on('click', '.remove_fields', function(event) {
      var fieldId, row = $(this).parents('tr');
      row.hide();
      row.find('input[type=hidden]').val('1');
      fieldId = "#"+ row.find('.grade_value').attr("id");

      removeFromValidation(fieldId);
      $(fieldId).parsley("removeConstraints", "range");
      alert($( '#report_card_form' ).parsley('isValid'));
      event.preventDefault();
    });
  }

  function initJQAddFields(){
    $('form').on('click', '.add_fields', function(event) {
      var newRow, idInfix;

      function replaceDummyId($addLink){
        var regexp = new RegExp($addLink.data('id'), 'g');
        var newRow =  $addLink.data('fields').replace(regexp, idInfix);
        return newRow
      }

      function add_row(row){
        $('#grades_table tbody').append(row)
        return false;
      }

      function idForValidation(){
        return "#report_card_grades_attributes_" +idInfix + "_value"
      }

      idInfix = new Date().getTime();
      newRow = replaceDummyId($(this));

      add_row(newRow);
      applyFieldValidations(extractValidations(), idForValidation())

      return event.preventDefault();
    });
  }

  function initJQGradeScaleChanged(){
    $("#grade_scale").change(function(){
      function confirmFormatChange(){
        var row_count, change_format
        row_count = $('#grades_table > tbody >tr:visible').length > 0
        return row_count>0 ? confirm("Are you sure? Changing the grade format will delelete your existing grades") : true;
      }

      if(confirmFormatChange()){
        $(".remove_fields").click();
      }
    });

  }

  function applyFieldValidations(validations, field){
    var custError, constraints = validations[0];

    if(validations[1] !== undefined){
      custError = validations[1].message;
    }
    custError && $(field ).data("error-message", custError) ;
    $( '#report_card_form' ).parsley('addItem', field);
    $(field ).parsley( 'addConstraint', constraints ); 
  }

  function extractValidations(){
    var select = $("#grade_scale")
    var opt = select.find(":selected")
    var index = parseInt(opt.val());
    return JSON.parse(select.data('validation-list')[index]);
  }

})();
