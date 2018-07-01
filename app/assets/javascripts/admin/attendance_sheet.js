//= require vue/components/attendance_tile

if(window.location.href.match(/attendance_sheets\/\d*/)){
  document.addEventListener('DOMContentLoaded', function(){

    var app = new Vue({
      el: '#app',
      components: {
        'attendance-tile': AttendanceTile,
      },

      data: {
        students: []
      },
      mounted: function(){
        this.loadStudents();
      },

      methods: {
        loadStudents: function(){
          var app = this;

          axios.get('/admin/attendance_sheets/409',{reponseType: 'json'})
            .then(function (response) {
              app.students =response.data;
            })
            .catch(function (error) {
            })
        }
      }
    });
  })
}
