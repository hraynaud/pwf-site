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
              <group-attendance-sheet v-if="isGroupAttendanceContext" 
              :attendees="attendees"
              :attendeeType="attendeeType"
              :missingImagePath="missingImagePath"
              v-on:toggled="handleToggle" 
              v-on:toggledAttendeeType="handleToggleAttendeeType"/>
        <single-attendance v-if="isSingleAttendanceContext" :sessions="sessions" v-on:session-updated="handleSessionUpdate"/>
        </div>
        `,
        components: {
          'group-attendance-sheet': GroupAttendanceSheet,
          'single-attendance': SingleAttendance,
        },
        mounted: function(){
          let appRootElement = document.getElementById("vue-app-container");

          this.loadPath = appRootElement.getAttribute('data-load-path');
          this.studentUpdatePath = appRootElement.getAttribute('data-student-update-path');
          this.staffUpdatePath = appRootElement.getAttribute('data-staff-update-path');
          this.missingImagePath = appRootElement.getAttribute("data-missing-img-path");

          if(this.isGroupAttendanceContext){
            this.loadAttendees();
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
          loadPath: "",
          staffUpdatePath: "",
          studentUpdatePath: "",
          missingImagePath: "",
          attendeeType: "student",
        },

        methods: {
          matchesPage: function(regex){
            return window.location.href.match(regex);
          },

          handleToggle: function(attendance){
            attendance.attended = !attendance.attended;
            this.updateAttendee(attendance);
          },

          handleToggleAttendeeType: function(type){
             this.attendeeType=type;
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

          loadAttendees: function(){
            var sheet = this;
            var url = this.loadPath + "?ajax=true"
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
            var url = this.loadPath + "?ajax=true"
            axios.get(url,{reponseType: 'json'})
              .then(function (response) {
                attendanceHistory.sessions = response.data;
              })
              .catch(function (error) {
              })
          },
          updateAttendanceForSession: function(session){
            let url = `${this.loadPath}`
            var attendanceHistory = this;
            axios.put(url,{attendance_id: session.attendanceId, attended: session.attended}, {reponseType: 'json'})
              .then(function (response) {
                attendanceHistory.sessions = response.data;
              })
              .catch(function (error) {
              })
          },

          isStudentAttendanceMode: function(){
            return this.attendeeType == "student"; 
          },

          createAttendanceForSession: function(sessionId){
            let url = `${this.loadPath}`
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
            return  this.isStudentAttendanceMode() ? this.students : this.staff;
          },

          updatePath: function(){
            return  this.isStudentAttendanceMode() ? this.studentUpdatePath : this.staffUpdatePath;
          },

        }
      });
    }
  })

})()
