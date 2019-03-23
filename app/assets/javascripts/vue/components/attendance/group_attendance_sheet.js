//=require ./attendance_tile

var GroupAttendanceSheet = {
  template: `
  <div class="student-grid">
  <attendance-tile v-for="(attendee, index) in attendees" :attendee="attendee" :key="attendee.id" :index="index" :missingImage="missingImagePath" v-on:toggled="toggle(attendee)"></attendance-tile></div>`,

  components: {
    'attendance-tile': AttendanceTile,
  },

  props: {
    attendees: Array,
    path: String,
    missingImagePath: String
  },

  methods: {
    toggle: function(attendee){
      this.$emit("toggled", attendee);
    }
  },

  computed: {
    filteredStudents: function() {
      let filtered = this.attendees;
      let searchText = this.search.toLowerCase();
      if (searchText) {
        filtered = this.attendees.filter(
          s => s.name.toLowerCase().indexOf(searchText) > -1
        );
      }
      return filtered;
    }
  }
};
