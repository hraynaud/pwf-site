var StudentSession ={
  props: ['session', 'index'],
  template: `<div class="session" v-on:click="update"><span>{{session.date}} <span>{{session.status}} </span></div>`,
  methods: {
    update: function(){
      this.$emit("updated")
    }
  }
};


