(function init(){
  $(function() {
    initJQAddfields();
    initJQRemoveFields();
  })

  function initJQAddfields(){
    $('form').on('click', '.remove_fields', function(event) {
      $(this).prev('input[type=hidden]').val('1');
      $(this).closest('tr').hide();
      return event.preventDefault();
    });
  }

  function initJQRemoveFields(){
    $('form').on('click', '.add_fields', function(event) {
      var new_row = replaceDummyId($(this));
      add_row(new_row);
      return event.preventDefault();
    });
  }
  function initJQGradeScaleChanged(){

  }

  function add_row(row){
    $(row).insertAfter('#grades_table tbody>tr:last');
    return false;
  }

  function replaceDummyId($addLink){
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($addLink.data('id'), 'g');
    return $addLink.data('fields').replace(regexp, time);
  }


})();
