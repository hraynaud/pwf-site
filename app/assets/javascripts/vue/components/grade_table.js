var GradeTable = {
  props:['propgrades'],
  data() {
    return{
    disabled: true
    }
  },
  methods:{
    deleteEvent: function(index) {
      this.propgrades.splice(index, 1);
    }
},
  template:
    `
  <table id="grade_table">
    <thead>
      <tr>
        <th> Id      </th>
        <th> Subject </th>
        <th> Grade   </th>
        <th> Score   </th>
        <th> </th>
      </tr>
    </thead>

    <tbody>

      <tr v-for="(grade, key, index) in propgrades">

        <td>
          <input type="text" v-model="grade.subject_name" v-bind:disabled="disabled" />
        </td>

        <td>
          <input type="text" v-model="grade.value" v-bind:disabled= "disabled" />
        </td>

        <td>
           <input type="text" v-model="grade.score" disabled="disabled" />
        </td>

        <td>
        <button @click="deleteEvent(index)">
                <i class="fa fa-times" aria-hidden="true"></i>
            Delete
            </button>
        </td>
      </tr>
    </tbody>

  </table>
`
};
