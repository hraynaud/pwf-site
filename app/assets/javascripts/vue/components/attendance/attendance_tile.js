var AttendanceTile ={
  props: ['attendee', 'index', 'missingImage'],
  template: `<div class="attendance" v-bind:class="{ attended: attendee.attended }" v-on:click="toggle">
  <img v-bind:src="image(attendee.thumbnail)"/>
  <div>{{attendee.name}}</div>
  </div>`,

  methods: {
    toggle: function(){
      this.$emit("toggled")
    },

    image: function(thumb){
      return thumb || this.missingImage;
    }
  }
};


