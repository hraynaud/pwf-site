var GradeForm = {
  template: `
<form>
  <table>
    <tbody>
      <tr>
        <td>
          <input type="text" v-model="grade.subject_name" placeholder="Subject" id="subject" name="subject_name">
        </td>
        <td>
          <input type="text" v-model="grade.value" placeholder="Grade" id="grade" name="value">
        </td>
      </tr>
  </table>
</form>
  `,

  props:['grade'],
   data: function() {
        return {
          subject_name: this.subject_name,
          value: this.value,
        };
      }
};

