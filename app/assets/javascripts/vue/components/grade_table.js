var GradeTable = {
  props:['propgrades'],
  data() {
    return{
      disabled: true
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

      <tr v-for="(grade, index) in propgrades">

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
        <a id="id+index" @click="$emit('delete',index)">
                <i class="icon-bin" aria-hidden="true"></i>
            </a>
        </td>
      </tr>
    </tbody>

  </table>
`
};
