//= require ../vue/components/attendance/group_attendance_sheet
//= require ../vue/components/attendance/single_attendance

(function(){

  function isAttendanceAppContext(){
    var attendanceAppContext = /\/attendance_sheets\/\d*$|student_registrations\/\d*\/edit/;
    return window.location.href.match(attendanceAppContext)
  }

  document.addEventListener('DOMContentLoaded', function(){

    if(isAttendanceAppContext()){
      new Vue({
        el: '#attendance-app',
        template: `
        <div class="wr-app-er">
        <label> Student
        <input type ="radio" name ="attendeeType" v-model="attendeeType" value="student" >
        </label>
        <label> Staff
        <input type ="radio" name ="attendeeType" v-model="attendeeType" value="staff" >
        </label>
        <group-attendance-sheet v-if="isGroupAttendanceContext" :attendees="attendees" :path="path" :missingImagePath="missingImagePath" v-on:toggled="handleToggle"/>
        <single-attendance v-if="isSingleAttendanceContext" :sessions="sessions" v-on:session-updated="handleSessionUpdate"/>
        </div>
        `,
        components: {
          'group-attendance-sheet': GroupAttendanceSheet,
          'single-attendance': SingleAttendance,
        },
        mounted: function(){
          let el = document.getElementById("vue-app-container");
          this.path = el.getAttribute('data-load-path');
          this.studentUpdatePath = el.getAttribute('data-student-update-path');
          this.staffUpdatePath = el.getAttribute('data-staff-update-path');
          this.missingImagePath = el.getAttribute("data-missing-img-path");
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
          staff: [],
          sessions: [],
          path: "",
          missingImagePath: "",
          attendeeType: "student"
        },
        
        methods: {
          matchesPage: function(regex){
            return window.location.href.match(regex);
          },

          handleToggle: function(attendance){
            attendance.attended = !attendance.attended;
            this.updateAttendee(attendance);
          },

          handleSessionUpdate: function(session){

            if(session.status == "missing"){
              this.createAttendanceForSession(session.id)
            }else {
              //toggle the current status
              session.attended = session.status == "present" ? false : true;
              this.updateAttendanceForSession(session)
            }

          },

          updateAttendee: function(attendance){
            let url = `${this.updatePath}/${attendance.id}`
            axios.put(url,{attended: attendance.attended}, {reponseType: 'json'})
              .then(function (response) {
                //no -op
              })
              .catch(function (error) {
                console.log(error);
              })
          },

          toggleAttendees: function(){
           debugger
          },

          loadStudents: function(){
            var sheet = this;
            var url = this.path + "?ajax=true"
            axios.get(url,{reponseType: 'json'})
              .then(function (response) {
                sheet.students = response.data.students;
                sheet.staff = response.data.staff;
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
          updateAttendanceForSession: function(session){
            let url = `${this.path}`
            var attendanceHistory = this;
            axios.put(url,{attendance_id: session.attendanceId, attended: session.attended}, {reponseType: 'json'})
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
          },
          attendees: function(){
            return this.attendeeType == "student" ? this.students : this.staff;
          },

          updatePath: function(){
            return this.attendeeType == "student" ? this.studentUpdatePath : this.staffUpdatePath;
          }

        }
      });
    }
  })

})()
