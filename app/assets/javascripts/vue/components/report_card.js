//= require ./grade_form
//= require ./grade_table

var ReportCard ={
  props:['disabled', 'getPath', 'postPath', 'deletePath', 'deleteEvent'],
  components: {
    'grade-form': GradeForm,
    'grade-table': GradeTable,
  },

template: `<div class="grades-panel"> 
  <grade-form v-bind:subjects="subjects" v-bind:disabled="disabled" v-bind:grade="grade" v-on:graded="addGrade(grade)" ></grade-form>
  <grade-table v-bind:propgrades="grades" v-bind:average="average" v-on:delete="deleteEvent"> </grade-table>
</div>`,

  data: function() {
    return {
      grade: {
        id:"",
        subject_name: "",
        value: "",
        score: "",
        errMsg: ""
      },
      grades: [],
      subjects: [],
      average: 0
    };
  },

  mounted: function(){
    this.loadGrades();
  },

  methods: {
    loadGrades: function(){
      axios.get(this.getPath,{reponseType: 'json'})
        .then(function (response) {
          this.grades = response.data.grades;
          this.subjects = response.data.subject_list;
          this.average = response.data.average;
        }.bind(this))
        .catch(function (error) {
        })
    },

    addGrade: function(event){
      let url = this.postPath;
      axios.post(url,this.grade, {reponseType: 'json'})
        .then(function (response) {
          this.addRow(response.data.grade);
          this.average = response.data.average;
        }.bind(this))
        .catch(function (error) {
          this.grade.errMsg = error.response.headers["x-message"];
        }.bind(this))
    },

    addRow: function(newGrade) {
      this.grades.push( newGrade );
    },
    deleteEvent: function(index, id) {
      let url = `${this.deletePath}/${id}`;
      axios.delete(url, {reponseType: 'json'})
        .then(function (response) {
          this.average = response.data.average;
          this.grades.splice(index, 1);
        }.bind(this))
        .catch(function (error) {
          this.grade.errMsg = error.response.headers["x-message"];
        }.bind(this))

    }
  }
};


