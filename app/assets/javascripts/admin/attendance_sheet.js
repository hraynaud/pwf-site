if(window.location.href.match(/attendance_sheets\/\d*/)){
  document.addEventListener('DOMContentLoaded', function(){
    var  app = new Vue({
      el: '#app',
      data: {
        message: 'Hello Vue.js!'
      }
    })
  })

  $.ajax({
    type: "GET",
    url: "/admin/attendance_sheets/409",
    data: "",
    dataType: "json",
    success: function(){
      console.log("!!!!SUCCESS");
    },
    error: function(){
    }
  });

}


