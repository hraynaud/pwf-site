  //= require vue-select
var GradeForm = {
  props:['subjects','grade', 'disabled'],
  components: {
    'v-select': VueSelect.VueSelect,
  },

  template: `
<div>
<div class="grade-form">
 <div>
   <v-select label="name" taggable push-tags v-model="selected"  v-bind:disabled="disabled" v-on:input="doChanged" placeholder="Subject" :options="subjects"></v-select>
 </div>
 <div> 
   <input type="text" v-model="grade.value" placeholder="Grade" id="grade" name="value"  v-bind:disabled="disabled">
 </div>
  <div>
  <button class="add-grade" v-on:click.prevent="addGrade" value="" v-bind:disabled="disabled">
    Add
  </button>
</div>
</div>
<div class="grade-error">{{grade.errMsg}}</div>

 </div>
  `,

  data: function(){
    return{
      selected: undefined,
    }
  },
  methods: {
    doChanged: function(e){
      if(e !== null){
        this.grade.id = e.id;
        this.grade.subject_name = e.name;
      }else{
        this.selected = undefined;
      }
    },
    addGrade: function(e){
      this.$emit("graded");
    }
  }
}

