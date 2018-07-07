//=require ./attendance_tile

var AttendanceSheet = {
  template: `<div class="student-grid">
  <attendance-tile v-for="(student, index, key) in students" v-bind:attendee="student" v-bind:key="student.id" v-bind:index="index" v-on:toggled="toggle"></attendance-tile></div>`,
  components: {
    'attendance-tile': AttendanceTile,
  },
  
  data: function(){
    return {
      students: []
    };
  },

  mounted: function(){
    this.loadStudents();
  },

  methods: {
    loadStudents: function(){
      var app = this;

      axios.get('/admin/attendance_sheets/409',{reponseType: 'json'})
        .then(function (response) {
          app.students =response.data.students;
        })
        .catch(function (error) {
        })
    },

    updateAttendee: function(){
      debugger
      let url = `/admin/attendance_sheets/409/attendences`
      axios.put(url,{reponseType: 'json'})
        .then(function (response) {
          app.students =response.data;
        })
        .catch(function (error) {
        })
    },

    toggle: function(index){
      let student = this.students[index];
      student.attended = !student.attended;
      this.updateAttendee(student.id)
    }
  }
};
