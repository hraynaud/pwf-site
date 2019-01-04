  //= require vue-select
var GradeForm = {
  props:['subjects','grade'],
  components: {
    'v-select': VueSelect.VueSelect,
  },

  template: `
<div>
<div class="grade-form">
<div style="display:inline-block">
<v-select label="name" v-model="selected"  v-on:input="doChanged" :options="subjects"></v-select>
</div>
<div style="display:inline-block"> <input type="text" v-model="grade.value" placeholder="Grade" id="grade" name="value"></div>
  <button class="add-grade" v-on:click.prevent="addGrade" value="">
    Add Grade
  </button>
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

