//= require ./grade_form
//= require ./grade_table

var ReportCard ={
  components: {
    'grade-form': GradeForm,
    'grade-table': GradeTable,
  },

template: `<div class="grades-panel"> 
  <grade-form v-bind:grade="grade"></grade-form>
  <div class="addRowBtn" v-on:click.prevent="addGrade" value="">
    <i class="fa fa-plus" aria-hidden="true">Add Row</i>
  </div>
  <grade-table v-bind:propgrades="grades"> </grade-table>
</div>`,

  data: function() {
    return {
      grade: {subject_name: "",
          value: "",
          score: ""
      },
      grades: [],
    };
  },

  mounted: function(){
    let el =document.getElementsByClassName("report-card")[0];
    this.path = el.getAttribute('data-reportcard-path');
    this.loadGrades(this.path);
  },

  methods: {

    addRow: function () {
      var newRow={
        subject_name: this.grade.subject_name,
        value: this.grade.value,
        score: ''
      };

      this.grades.push( newRow );
    },


    loadGrades: function(){
      var card = this;
      axios.get(this.path,{reponseType: 'json'})
        .then(function (response) {
          card.grades =response.data;
        })
        .catch(function (error) {
        })
    },

    addGrade: function(event){
      let url = this.path;
      axios.post(url,this.grade, {reponseType: 'json'})
        .then(function (response) {
          this.addRow();
        }.bind(this))
        .catch(function (error) {
        })
    },
  }
};


