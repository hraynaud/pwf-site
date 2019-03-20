//=require ./attendance_tile

var AllAttendanceSheet = {
  template: `
  <div class="student-grid"><div class="search-form"> <label>Search by name: </label>
  <span class="input-wrapper"><input v-model="search" class="search-input"> </span><div>
  <attendance-tile v-for="(attendee, index) in filteredAttendees" :attendee="attendee" :key="attendee.id" :index="index" :missingImage="missingImagePath" v-on:toggled="toggle(attendee)"></attendance-tile></div>`,

  components: {
    'attendance-tile': AttendanceTile,
  },

  props: {
    attendees: Array,
    path: String,
    missingImagePath: String
  },

  data: function(){
    return {
      search: ""
    }
  },

  methods: {
    toggle: function(attendee){
      this.$emit("toggled", attendee);
    }
  },

  computed: {
    filteredAttendees: function() {
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
