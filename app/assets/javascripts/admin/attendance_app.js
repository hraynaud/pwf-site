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
        <group-attendance-sheet v-if="isGroupAttendanceContext" :students="students" :path="path" v-on:toggled="handleToggle"/>
        <single-attendance-sheet v-if="isSingleAttendanceContext"/>
        `,
        components: {
          'group-attendance-sheet': GroupAttendanceSheet,
          'single-attendance': SingleAttendance,
        },
        mounted: function(){
          let el = document.getElementsByClassName("attendance-sheet")[0];
          this.path = el.getAttribute('data-sheet-path');
          this.loadStudents(this.path);
        },
        data: {
          singleAttendanceRegex: /student_registrations\/edit\/\d*/,
          groupAttendanceRegex:  /attendance_sheets\/\d*/,
          students: [],
          path: ""
        },

        methods: {
          matchesPage: function(regex){
            return window.location.href.match(regex);
          },

          handleToggle: function(index){
            let student = this.students[index];
            student.attended = !student.attended;
            this.updateAttendee(student);
          },

          updateAttendee: function(student){

            let url = `${this.path}/attendances/${student.id}`
            axios.put(url,{attended: student.attended}, {reponseType: 'json'})
              .then(function (response) {
                app.students =response.data;
              })
              .catch(function (error) {
              })
          },
          loadStudents: function(){
            var sheet = this;
            var url = this.path + "?ajax=true"
            axios.get(url,{reponseType: 'json'})
              .then(function (response) {
                sheet.students =response.data.students;
              })
              .catch(function (error) {
              })
          },
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
