var AttendanceTile ={
  props: ['attendee', 'index'],
  template: `<label class="attendance" v-bind:class="{ attended: attendee.attended }" v-on:click="toggle">
  <img v-bind:src="attendee.thumbnail"/>
  <span>{{attendee.name}}</span>
  </label>`,

  methods: {
    toggle: function(){
      this.$emit("toggled", this.index)
    }
  }
};


