//=require ./attendance_tile

var AttendanceSheet = {
  template: `<div class="student-grid">
 <div> <label>Search By name: <input v-model="search"> </label> <div>
  <attendance-tile v-for="(student, index, key) in filteredStudents" v-bind:attendee="student" v-bind:key="student.id" v-bind:index="index" v-on:toggled="toggle"></attendance-tile>
  </div>`,
  components: {
    'attendance-tile': AttendanceTile,
  },

  data: function(){
    return {
      students: [],
      path: "",
      search: ""
    };
  },

  mounted: function(){
   let el =document.getElementsByClassName("attendance-sheet")[0];
    this.path = el.getAttribute('data-sheet-path');
    this.loadStudents(this.path);
  },

  methods: {
    loadStudents: function(){
      var sheet = this;

      axios.get(this.path,{reponseType: 'json'})
        .then(function (response) {
          sheet.students =response.data.students;
        })
        .catch(function (error) {
        })
    },

    updateAttendee: function(id){
      let url = `${this.path}/attendances/${id}`
      axios.put(url,{attended: true}, {reponseType: 'json'})
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
  },
    computed: {
    filteredStudents: function() {
      let filtered = this.students;
      if (this.search) {
        filtered = this.students.filter(
          s => s.name.toLowerCase().indexOf(this.search) > -1
        );
      }
      return filtered;
    }
  }
};
