//=require ./student_session

var SingleAttendance = {
  template: `<div class="session-list">
  <student-session v-for="(session, index) in sessions" :session="session" :key="session.id" :index="index" v-on:updated="updated(session)"></student-session>
  </div>`
  ,
  props:  {sessions: Array},
  components: {
    'student-session': StudentSession,
  },

  methods: {
    updated: function(session){
     this.$emit("session-updated", session); 
    }
  },
};
