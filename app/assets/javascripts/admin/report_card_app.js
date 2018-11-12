//= require ../vue/components/grade_form
//= require ../vue/components/grade_table
if(window.location.href.match(/grades/)){
  document.addEventListener('DOMContentLoaded', function(){

    new Vue({
      el: '#report-card-app',
      components: {
        'grade-form': GradeForm,
        'grade-table': GradeTable,
      },

      data: function() {
        return {
          grades: [ 
            { id:0, subject: 'Computer Science', grade: 87, score:'' }
          ],
          nextBarId: 1
        };
      },
      methods: {
        addRow: function (event) {
          lastId =  this.grades.length;
          var newRow={
            id: this.nextBarId++,
            subject: this.subject,
            grade: this.grade ,
            score: this.score
          };
          this.grades.push( newRow );
        }
      }
    });

  });
}
