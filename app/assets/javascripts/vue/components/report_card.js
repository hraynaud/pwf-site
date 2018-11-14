//= require ./grade_form
//= require ./grade_table

var ReportCard ={
  components: {
    'grade-form': GradeForm,
    'grade-table': GradeTable,
  },

template: `<div class="grades-panel"> 
  <grade-form></grade-form>
  <grade-table v-bind:propgrades="grades"> </grade-table>
  <div class="addRowBtn" v-on:click.prevent="addRow" value="">
    <i class="fa fa-plus" aria-hidden="true">Add Row</i>
  </div>
</div>`,

  data: function() {
    return {
      grades: [ 
        { id:0, subject: 'Computer Science', grade: 87, score:'' }
      ],
      nextBarId: 1
    };
  },

  mounted: function(){
    let el =document.getElementsByClassName("report-card")[0];
    this.path = el.getAttribute('data-reportcard-path');
    this.loadGrades(this.path);
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
    },

    loadGrades: function(){
      var card = this;

      axios.get(this.path,{reponseType: 'json'})
        .then(function (response) {
          card.grades =response.data.grades;
        })
        .catch(function (error) {
        })
    },

    //updateGrades: function(id){
      //let url = `${this.path}/attendances/${id}`
      //axios.put(url,{attended: true}, {reponseType: 'json'})
        //.then(function (response) {
          //app.students =response.data;
        //})
        //.catch(function (error) {
        //})
    //},
  }
};


