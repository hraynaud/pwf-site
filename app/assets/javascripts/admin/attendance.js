//= require ../vue/components/attendance_sheet
if(window.location.href.match(/attendance_sheets\/\d*/)){
  document.addEventListener('DOMContentLoaded', function(){

   new Vue({
      el: '#attendance-app',
      template: '<attendance-sheet/>',
      components: {
        'attendance-sheet': AttendanceSheet,
      },
    });
  })
}
