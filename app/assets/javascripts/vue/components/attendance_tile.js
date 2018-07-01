Vue.component('attendance-tile', {
  props: ['attendee'],
  template: '<label class="attendance"><span>{{attendee.name}} </span></label>'
})
