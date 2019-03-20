//= require ../vue/components/attendance/all_attendance_sheet
//= require ../vue/components/attendance/single_attendance

(function(){

  function isAttendanceAppContext(){
    var attendanceAppContext = /staff_attendance_sheets\/\d*$/;
    return window.location.href.match(attendanceAppContext)
  }

  document.addEventListener('DOMContentLoaded', function(){

    if(isAttendanceAppContext()){

      new Vue({
        el: '#staff-attendance-app',
        template: `
        <div class="wr-app-er">
        <all-attendance-sheet v-if="isGroupAttendanceContext" :attendees="attendees" :path="path" :missingImagePath="missingImagePath" v-on:toggled="handleToggle"/>
        <single-attendance v-if="isSingleAttendanceContext" :sessions="sessions" v-on:session-updated="handleSessionUpdate"/>
        </div>
        `,
        components: {
          'all-attendance-sheet': AllAttendanceSheet,
          'single-attendance': SingleAttendance,
        },
        mounted: function(){
          let el = document.getElementById("vue-app-container");
          this.path = el.getAttribute('data-load-path');
          this.missingImagePath = el.getAttribute("data-missing-img-path");
          if(this.isGroupAttendanceContext){
            this.loadAttendees();
          }else{
            this.loadStudentAttendanceHistory();
          }
        },
        data: {
          singleAttendanceRegex: /_registrations\/\d*\/edit/,
          groupAttendanceRegex:  /staff_attendance_sheets\/\d*/,
          attendees: [],
          sessions: [],
          path: "",
          missingImagePath: ""
        },

        methods: {
          matchesPage: function(regex){
            return !!window.location.href.match(regex);
          },

          handleToggle: function(attendee){
            attendee.attended = !attendee.attended;
            this.updateAttendee(attendee)
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

          updateAttendee: function(attendee){
            let url = `${this.path}/staff_attendances/${attendee.id}`
            axios.put(url,{attended: attendee.attended}, {reponseType: 'json'})
              .then(function (response) {
                //no -op
              })
              .catch(function (error) {
                console.log(error);
              })
          },


          loadAttendees: function(){
            var sheet = this;
            var url = this.path + "?ajax=true"
            axios.get(url,{reponseType: 'json'})
              .then(function (response) {
                sheet.attendees =response.data.attendees;
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
          }
        }
      });
    }
  })

})()
