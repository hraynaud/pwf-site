(function init(){
  $(function(){
    preventMousedownGhosting();
    setAttendedBackground();
    toggleAttendance();
  });

  function preventMousedownGhosting(){
    $("label.attendance").mousedown(function(event){ event.preventDefault(); });
  }

  function setAttendedBackground(){
    $("input[type=checkbox]:checked").prev().prev().css("background-color",$("#present-key").css("background-color"));
  }

  function toggleAttendance(){
    $(".attendance").click( function() {
      var id = $(this).attr("for");
      var $el = $("#"+id);
      var value =$el.val();
      var name = $el.attr("name");

      if ($el.is(':checked')) {
        $(this).css("background-color",$("#absent-key").css("background-color"));
        $el.attr("checked", false);
      }
      else {
        $(this).css("background-color",$("#present-key").css("background-color"));
        $el.attr("checked", true);
      }


      $.ajax({
        type: "PUT",
        url: "/attendances/" + $(this).data("db-id"),
        data: "present="+$el.attr("checked"),
        dataType: "json",
        success: function(){
          console.log("!!!!SUCCESS");
        },
        error: function(){
        }
      });

    });
  }
})();
