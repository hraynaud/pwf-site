var AttendanceTile ={
  props: ['attendee', 'index'],
  template: `<div class="attendance" v-bind:class="{ attended: attendee.attended }" v-on:click="toggle">
  <img v-bind:src="attendee.thumbnail"/>
  <div>{{attendee.name}}</div>
  </div>`,

  methods: {
    toggle: function(){
      this.$emit("toggled")
    }
  }
};


