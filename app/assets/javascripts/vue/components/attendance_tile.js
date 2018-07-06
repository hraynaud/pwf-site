var AttendanceTile ={
  props: ['attendee'],
  template: '<label class="attendance" v-on:click="toggle" v-bind:class="{ attended: attendee.attended }"><span>{{attendee.name}} </span></label>',
  methods: {
    toggle: function(){
      this.attendee.attended = !this.attendee.attended;
    }
  }
};


