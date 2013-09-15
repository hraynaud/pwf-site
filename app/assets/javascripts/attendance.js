(function init(){
  $(function(){
    preventMousedownGhosting();
    setAttendedBackground();
    toggleAttendance()
  });

  function preventMousedownGhosting(){
    $("label.attendance").mousedown(function(event){ event.preventDefault(); });
  }

  function setAttendedBackground(){
    $("input[type=checkbox]:checked").prev().prev().css("background-color",$("#present-key").css("background-color"));
  }

  function toggleAttendance(){
    $(".attendance").click(
      function() {
      var id = $(this).attr("for");
      if ($("#"+id).is(':checked')) {
        //switching from selected to unselected
        $(this).css("background-color",$("#absent-key").css("background-color"));
      }
      else {
        $(this).css("background-color",$("#present-key").css("background-color"));
      }
    });
  }
})();
