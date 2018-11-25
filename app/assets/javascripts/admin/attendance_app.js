//= require ../vue/components/attendance/group_attendance_sheet
//= require ../vue/components/attendance/single_attendance

(function(){

  function isAttendanceAppContext(){
    var attendanceAppContext = /attendance_sheets\/\d*|student_registrations\/edit\/\d*/;
    return window.location.href.match(attendanceAppContext)
  }

  document.addEventListener('DOMContentLoaded', function(){

    if(isAttendanceAppContext()){

      new Vue({
        el: '#attendance-app',
        template: `
        <group-attendance-sheet v-if="isGroupAttendanceContext"/>
        <single-attendance-sheet v-if="isSingleAttendanceContext"/>
        `,
        components: {
          'group-attendance-sheet': GroupAttendanceSheet,
          'single-attendance': SingleAttendance,
        },

        data: {
          singleAttendanceRegex: /student_registrations\/edit\/\d*/,
          groupAttendanceRegex:  /attendance_sheets\/\d*/
        },

        methods: {
          matchesPage: function(regex){
            return window.location.href.match(regex);
          }
        },

        computed: {
          isGroupAttendanceContext: function(){
            return this.matchesPage(this.groupAttendanceRegex);
          },
          isSingleAttendanceContext: function(){
            return this.matchesPage(this.groupAttendanceRegex);
          }
        }
      });
    }
  })

})()
