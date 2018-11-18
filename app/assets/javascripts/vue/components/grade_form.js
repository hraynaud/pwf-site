//= require ./select_chosen
var GradeForm = {
  props:['subjects','grade'],
   components: {
    'select-chosen': SelectChosen,
  },

  template: `
<form>
  <table>
    <tbody>
      <tr>
        <td>
       <select-chosen  v-bind:options="subjects" v-on:changed="doChanged" /> 
<span>Selected: {{grade.subject_name}}</span>
        </td>
        <td>
          <input type="text" v-model="grade.value" placeholder="Grade" id="grade" name="value">
        </td>
      </tr>
  </table>
</form>
  `,
  methods: {
    doChanged: function(text, id){
      this.grade.id = id;
      this.grade.subject_name = text;
    },
  }
};

