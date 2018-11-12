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

      <tr v-for="(val, key, index) in propgrades">
        <td>
           <input type="text" v-model="val.id" disabled="disabled" />
        </td>

        <td>
          <input type="text" v-model="val.subject" v-bind:disabled="disabled" />
        </td>

        <td>
          <input type="text" v-model="val.grade" v-bind:disabled= "disabled" />
        </td>

        <td>
           <input type="text" v-model="val.score" disabled="disabled" />
        </td>

        <td>
        <button @click="deleteEvent(index)">
                <i class="fa fa-times" aria-hidden="true"></i>
            Delete
            </button>
<span class="edit_mode" @click="disabled = !disabled">
                <i class="fa fa-pencil-square-o" aria-hidden="true"></i>
                Edit
            </span> 
        </td>

      </tr>

    </tbody>

  </table>
`
};
