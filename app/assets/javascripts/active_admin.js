//= require active_admin/base
//= require chosen-jquery
//= require vue.min
//= require axios.min
//= require lib/axios_config
//= require admin/attendance_sheet

$(document).ready(function() {
  $('.filter_form select').chosen({
    width: '200px'
  })
});
