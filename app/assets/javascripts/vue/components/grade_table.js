var GradeTable = {
  props:['propgrades', 'average'],
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
        <a class="del-icon" id="id+index" @click="$emit('delete',index, grade.id)">
                <i class="icon-bin" aria-hidden="true"></i>
            </a>
        </td>
      </tr>
      
    </tbody>
<tr>
      <td colspan="2" class="calc-gpa-label">Calculated GPA: </td>
      <td class="calc-gpa-value">{{average}}</td>
    </tr>
    <tfoot>
  </tfoot>
  </table>
`
};
