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
      const tabs = [
        {
          name: 'Group',
          component: GroupAttendanceSheet
        },
      ];

      const AttendeeTypes=Object.freeze({ STUDENT: {name: "student", key: "student_registration_id"},  STAFF: {name: "staff", key: "staff_id" } } );

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
          this.initData();
          this.loadAttendees();
        },

        data: {
          sheetId: "",
          sessionDate:"",
          students: [],
          unattachedStudents: [],
          unattachedStaff: [],
          staff: [],
          loadPath: "",
          staffUpdatePath: "",
          studentUpdatePath: "",
          missingImagePath: "",
          baseCreateParams: {attended: true, attendance_sheet_id: null},
          attendeeType: AttendeeTypes.STUDENT.name,
          tabs: tabs,
          currentTab: tabs[0],
        },

        methods: {

          initData: function(){

            this.loadPath = this.initValFor('load-path');
            this.studentUpdatePath = this.initValFor('student-update-path');
            this.staffUpdatePath = this.initValFor('staff-update-path');
            this.missingImagePath = this.initValFor("missing-img-path");
            this.sheetId = this.initValFor("sheet-id");
            this.sessionDate = this.initValFor("session-date");
            this.baseCreateParams.attendance_sheet_id = this.sheetId;
          },

          initValFor: function(attrName){
            let appRootElement = document.getElementById("vue-app-container");
            let attribute = "data-"+attrName;
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
            axios.post(url, this.createParams(attendee), {reponseType: 'json'})
              .then(function (response) {

              })
              .catch(function (error) {
              })
          },

          handleToggleAttendeeType: function(type){
            this.attendeeType=type;
          },

          createParams: function(attendee){
            params = this.baseCreateParams;
            let key = this.attendeeType == AttendeeTypes.STUDENT.name ? AttendeeTypes.STUDENT.key : AttendeeTypes.STAFF.key
            params[key] = attendee.userid
            return params
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
                sheet.staff = response.data.staff;
                sheet.unattachedStudents = response.data.unattachedStudents;
                sheet.unattachedStaff= response.data.unattachedStaff;
              })
              .catch(function (error) {
              })
          },

          isStudentAttendanceMode: function(){
            return this.attendeeType == AttendeeTypes.STUDENT.name; 
          },

          attendees: function(){
            return  this.isStudentAttendanceMode() ? this.students.concat(this.unattachedStudents) : this.staff.concat(this.unattachedStaff);
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

