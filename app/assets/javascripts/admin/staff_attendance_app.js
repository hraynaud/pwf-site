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
        el: '#attendance-app',
        template: `
        <div class="wr-app-er">
        <label> Staff
        <input type ="radio" name ="attendeeType" v-model="attendeeType" value="staff">
        </label>
        <label> Student
        <input type ="radio" name ="attendeeType" v-model="attendeeType" value="student">
        </label>
        <all-attendance-sheet v-if="isGroupAttendanceContext" :attendees="attendees" :path="path" :missingImagePath="missingImagePath" v-on:toggled="handleToggle"/>
        </div>
        `,
        components: {
          'all-attendance-sheet': AllAttendanceSheet,
        },
        mounted: function(){
          let el = document.getElementById("vue-app-container");
          this.path = el.getAttribute('data-load-path');
          this.missingImagePath = el.getAttribute("data-missing-img-path");
          this.loadAttendees();
        },
        data: {
          attendees: [],
          sessions: [],
          path: "",
          missingImagePath: "",
          attendeeType: "staff"
        },

        methods: {
          matchesPage: function(regex){
            return !!window.location.href.match(regex);
          },

          updatePath: function(id){
            return `${this.path}/${this.attendeeTypePathSegment()}/${id}`;
          },

          attendeeTypePathSegment: function(){
            return this.attendeetype = "staff" ? "staff_attendances" : "attendances"
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
            let url = this.updatePath(attendee.id);
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

          loadAttendanceHistory: function(){
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
            //return this.matchesPage(this.groupAttendanceRegex);
            return true
          },
        }
      });
    }
  })

})()
