//=require ./attendance_tile

var GroupAttendanceSheet = {
  template: `<div class="student-grid">
 <div> <label>Search By name: <input v-model="search"> </label> <div>
  <attendance-tile v-for="(student, index) in filteredStudents" :attendee="student" :key="student.id" :index="index" v-on:toggled="toggle(student)"></attendance-tile>
  </div>`,
  components: {
    'attendance-tile': AttendanceTile,
  },

  props: {
    students: Array,
    path: String
  },

  data: function(){
    return {
      search: ""
    }
  },

  methods: {
    toggle: function(student){
      this.$emit("toggled", student);
    }
  },

  computed: {
    filteredStudents: function() {
      let filtered = this.students;
      let searchText = this.search.toLowerCase();
      if (searchText) {
        filtered = this.students.filter(
          s => s.name.toLowerCase().indexOf(searchText) > -1
        );
      }
      return filtered;
    }
  }
};
