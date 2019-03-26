//= require ../vue/components/attendance/group_attendance_sheet
//= require ../vue/components/attendance/single_attendance

(function(){

  function isAttendanceAppContext(){
    var attendanceAppContext = /\/attendance_sheets\/\d*$|student_registrations\/\d*\/edit/;
    return window.location.href.match(attendanceAppContext)
  }

  document.addEventListener('DOMContentLoaded', function(){

    if(isAttendanceAppContext()){
      var tabs = [
        {
          name: 'Group',
          component: GroupAttendanceSheet
        },
        {
          name: 'Single',
          component: SingleAttendance
        }
      ];

      new Vue({
        el: '#attendance-app',
        template: `
      <div class="attendance-manager">
        <button v-for="tab in tabs"
          v-bind:key="tab.name"
          v-bind:class="['tab-button',  { active: currentTab.name === tab.name }]"
          v-on:click="currentTab = tab">

          {{ tab.name }}

        </button>
        <div class="wr-app-er">
          <component v-bind:is="currentTab.component" class="tab" v-bind="componentProperties" v-on="eventHandlers">
          </component>
        </div>
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
          this.sheetId = appRootElement.getAttribute("data-sheet-id");
          this.sessionDate = appRootElement.getAttribute("data-session-date");

          if(this.isGroupAttendanceContext){
            this.loadAttendees();
          }else{
            this.loadStudentAttendanceHistory();
          }
        },
        data: {
          singleAttendanceRegex: /student_registrations\/\d*\/edit/,
          groupAttendanceRegex:  /attendance_sheets\/\d*/,
          sheetId: "",
          sessionDate:"",
          students: [],
          unattached: [],
          staff: [],
          sessions: [],
          loadPath: "",
          staffUpdatePath: "",
          studentUpdatePath: "",
          missingImagePath: "",
          attendeeType: "student",
          currentTab: 'Group',
          tabs: tabs,
          currentTab: tabs[0],
        },

        methods: {
          matchesPage: function(regex){
            return window.location.href.match(regex);
          },

          handleToggle: function(attendee){
            attendee.attended = !attendee.attended;
            if(attendee.attended === null){
              this.createAttendance(attendee)
            }else{
              this.updateAttendee(attendee);
            }
          },

          createAttendance: function(attendee){
            let url = this.updatePath;
            axios.post(url,{attendance_sheet_id: this.sheetId, student_registration_id: attendee.reg, attended: true}, {reponseType: 'json'})
              .then(function (response) {

              })
              .catch(function (error) {
              })
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
                sheet.unattached = response.data.unattached;
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

          attendees: function(){
            return  this.isStudentAttendanceMode() ? this.students.concat(this.unattached) : this.staff;
          },
        },

        computed: {
          isGroupAttendanceContext: function(){
            return this.matchesPage(this.groupAttendanceRegex);
          },

          isSingleAttendanceContext: function(){
            return this.matchesPage(this.singleAttendanceRegex);
          },

          updatePath: function(){
            return  this.isStudentAttendanceMode() ? this.studentUpdatePath : this.staffUpdatePath;
          },

          groupProps: function(){
            return {
              attendees: this.attendees(),
              attendeeType: this.attendeeType,
              missingImagePath: this.missingImagePath,
            };

          },

          eventHandlers: function(){
            return {
              toggled: this.handleToggle,
              toggledAttendeeType: this.handleToggleAttendeeType
            };
          },

          componentProperties: function(){
            return this.currentTab.name == "Group" ? this.groupProps : {};
          }

        }
      });
    }
  })

})()

