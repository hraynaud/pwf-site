var GradeForm = {
  template: `
<form>
 <table>
        <tbody>
          <tr>
<td>
<input type="text" v-model="subject" placeholder="Subject" id="subject" name="subject">
</td>
<td>
<input type="text" v-model="grade" placeholder="Grade" id="grade" name="grade">
</td>
</tr>
</form>
  `,
   data: function() {
        return {
          subject: '',
          grade: '',
        };
      }
};

