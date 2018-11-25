//= require ../vue/components/attendance/group_attendance_sheet
//= require ../vue/components/attendance/single_attendance

(function(){

  function isAttendanceAppContext(){
    var attendanceAppContext = /attendance_sheets\/\d*|student_registrations\/\d*\/edit/;
    return window.location.href.match(attendanceAppContext)
  }

  document.addEventListener('DOMContentLoaded', function(){

    if(isAttendanceAppContext()){

      new Vue({
        el: '#attendance-app',
        template: `
        <div class="wr-app-er">
        <group-attendance-sheet v-if="isGroupAttendanceContext" :students="students" :path="path" v-on:toggled="handleToggle"/>
        <single-attendance v-if="isSingleAttendanceContext" :sessions="sessions" v-on:sessionUpdated="handleSessionUpdate"/>
        </div>
        `,
        components: {
          'group-attendance-sheet': GroupAttendanceSheet,
          'single-attendance': SingleAttendance,
        },
        mounted: function(){
          let el = document.getElementById("vue-app-container");
          this.path = el.getAttribute('data-load-path');
          if(this.isGroupAttendanceContext){
            this.loadStudents();
          }else{
            this.loadStudentAttendanceHistory();
          }
        },
        data: {
          singleAttendanceRegex: /student_registrations\/\d*\/edit/,
          groupAttendanceRegex:  /attendance_sheets\/\d*/,
          students: [],
          sessions: [],
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

          handleSessionUpdate: function(index, status, attendanceId){
            let session = this.sessions[index];
            if(status == "missing"){
              this.createAttendanceForSession(session.id)
            }else {
              //toggle the current status
              var attended = status == "present" ? false : true;
              this.updateAttendanceForSession(attendanceId, attended)
            }

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

          loadStudentAttendanceHistory: function(){
            var attendanceHistory = this;
            var url = this.path + "?ajax=true"
            axios.get(url,{reponseType: 'json'})
              .then(function (response) {
                attendanceHistory.sessions = response.data;
              })
              .catch(function (error) {
              })
          },
          updateAttendanceForSession: function(attendanceId, attended){
            let url = `${this.path}`
            var attendanceHistory = this;
            axios.put(url,{attendance_id: attendanceId, attended: attended}, {reponseType: 'json'})
              .then(function (response) {
                attendanceHistory.sessions = response.data;
              })
              .catch(function (error) {
              })
          },

          createAttendanceForSession: function(sessionId){
            let url = `${this.path}`
            var attendanceHistory = this;
            axios.post(url,{sheet_id: sessionId}, {reponseType: 'json'})
              .then(function (response) {
                attendanceHistory.sessions = response.data;
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
            return this.matchesPage(this.singleAttendanceRegex);
          }
        }
      });
    }
  })

})()
