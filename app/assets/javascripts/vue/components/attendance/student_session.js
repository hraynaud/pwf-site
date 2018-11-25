var StudentSession ={
  props: ['session', 'index'],
  template: `<div class="session" v-on:click="update"><span>{{session.date}} <span>{{session.status}} </span></div>`,
  methods: {
    update: function(e){
      this.$emit("updated", this.index, this.session.status, this.session.attendanceId)
    }
  }
};


