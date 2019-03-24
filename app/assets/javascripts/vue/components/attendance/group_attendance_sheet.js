//=require ./attendance_tile

var GroupAttendanceSheet = {
  template: `
  <div class="group-attendance">
   <div class="attendance-filter">
        <span class="filter-label">Attendee type: </span>
        <label class="radio-wrap"> Student
          <input type ="radio" name ="attendeeType" v-model="attendeeType" value="student" v-on:change="toggleAttendeeType" >
        </label>
        <label class="radio-wrap"> Staff
          <input type ="radio" name ="attendeeType" v-model="attendeeType" value="staff" v-on:change="toggleAttendeeType">
        </label>
        <span class="search-form">
          <span class="filter-label">Search by name: </span>
          <input v-model="search" class="search-input" type="text"> 
        </span>
   </div>

    <div class="student-grid">
      <attendance-tile v-for="(attendee, index) in filteredAttendees" 
        :attendee="attendee" 
        :key="attendee.id" 
        :index="index" 
        :missingImage="missingImagePath" 
        v-on:toggled="toggle(attendee)">
      </attendance-tile>
    </div>
  </div>`,

  components: {
    'attendance-tile': AttendanceTile,
  },

  data: function(){
    return {
      search: "",
    };
  },

  props: {
    missingImagePath: String,
    attendees: Array,
    attendeeType: String,
  },

  methods: {
    toggle: function(attendee){
      this.$emit("toggled", attendee);
    },

    toggleAttendeeType: function(event){
      this.$emit("toggledAttendeeType", event.target.value);
    },

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
    },

  }
};
