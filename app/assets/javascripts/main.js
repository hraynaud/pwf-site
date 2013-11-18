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
