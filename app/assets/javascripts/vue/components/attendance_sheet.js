//=require ./attendance_tile

var AttendanceSheet = {
  template: '<div class="student-grid"><attendance-tile v-for="student in students" v-bind:attendee="student" v-bind:key="student.id"> </attendance-tile></div>',
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
          app.students =response.data;
        })
        .catch(function (error) {
        })
    }
  }
};
