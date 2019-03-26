//= require ../vue/components/attendance/group_attendance_sheet

(function(){

  function isAttendanceAppContext(){
    var attendanceAppContext = /\/attendance_sheets\/\d*$/;
    return window.location.href.match(attendanceAppContext)
  }

  document.addEventListener('DOMContentLoaded', function(){

    if(isAttendanceAppContext()){

      /*
       * NOTE: Since there is only one tab we technically don't even need to
       * use a dynamic component but keep this code for future reference on how
       * to implement dynamically rendered components
       * just add another tab and modify componentProperties and eventHandlers
       * computed propertes as necessary
       */
      var tabs = [
        {
          name: 'Group',
          component: GroupAttendanceSheet
        },
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
        },

        mounted: function(){

          this.loadAttendees();
        },

        data: {
          sheetId: "",
          sessionDate:"",
          students: [],
          unattached: [],
          staff: [],
          loadPath: "",
          staffUpdatePath: "",
          studentUpdatePath: "",
          missingImagePath: "",
          attendeeType: "student",
          tabs: tabs,
          currentTab: tabs[0],
        },

        methods: {

          initData: function(){

            this.loadPath = this.initValFor('data-load-path');
            this.studentUpdatePath = this.initValFor('data-student-update-path');
            this.staffUpdatePath = this.initValFor('data-staff-update-path');
            this.missingImagePath = this.initValFor("data-missing-img-path");
            this.sheetId = this.initValFor("data-sheet-id");
            this.sessionDate = this.initValFor("data-session-date");
          },

          initValFor: function(attribute){
            let appRootElement = document.getElementById("vue-app-container");
            return appRootElement.getAttribute(attribute);
          },

          handleToggle: function(attendee){
            if(attendee.attended === null){
              this.createAttendance(attendee)
              attendee.attended = true
            }else{
              attendee.attended = !attendee.attended;
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

          updateAttendee: function(attendee){
            let url = `${this.updatePath}/${attendee.id}`
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

          isStudentAttendanceMode: function(){
            return this.attendeeType == "student"; 
          },

          attendees: function(){
            return  this.isStudentAttendanceMode() ? this.students.concat(this.unattached) : this.staff;
          },
        },

        computed: {

          updatePath: function(){
            return  this.isStudentAttendanceMode() ? this.studentUpdatePath : this.staffUpdatePath;
          },


          /*
           * NOTE: keeps this as an simple  example of how to dynamically
           * select properties and handlers for dynamic components
           */

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
            return this.currentTab == this.tabs[0] ? this.groupProps : {};
          }

        }
      });
    }
  })

})()

