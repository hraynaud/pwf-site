//= require ../vue/components/attendance/single_attendance

(function(){

  function isAttendanceAppContext(){
    var attendanceAppContext = /student_registrations\/\d*\/edit/;
    return window.location.href.match(attendanceAppContext)
  }

  document.addEventListener('DOMContentLoaded', function(){

    if(isAttendanceAppContext()){
      new Vue({
        el: '#attendance-app',
        template: `
      <div class="attendance-manager">
        <div class="wr-app-er">
         <single-attendance :sessions="sessions" v-on:session-updated="handleSessionUpdate"/>
        </div>
        </div>
        `,
        components: {
          'single-attendance': SingleAttendance,
        },
        mounted: function(){
          let appRootElement = document.getElementById("vue-app-container");
          this.loadPath = appRootElement.getAttribute('data-load-path');
          this.loadStudentAttendanceHistory();
        },

        data: {
          sessions: [],
          loadPath: "",
        },

        methods: {
          handleSessionUpdate: function(session){
            if(session.status == "missing"){
              this.createAttendanceForSession(session.id)
            }else {
              //toggle the current status
              session.attended = session.status == "present" ? false : true;
              this.updateAttendanceForSession(session)
            }
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
            var attendanceHistory = this;

            axios.put(this.loadPath,{attendance_id: session.attendanceId, attended: session.attended}, {reponseType: 'json'})
              .then(function (response) {
                attendanceHistory.sessions = response.data;
              })
              .catch(function (error) {
              })
          },

          createAttendanceForSession: function(sessionId){
            var attendanceHistory = this;
            axios.post(this.loadPath,{sheet_id: sessionId}, {reponseType: 'json'})
              .then(function (response) {
                attendanceHistory.sessions = response.data;
              })
              .catch(function (error) {
              })
          },

        },
      });
    }
  })

})()

