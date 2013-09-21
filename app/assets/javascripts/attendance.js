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
    $(".attendance").click( function() {
      var id = $(this).attr("for");
      var $el = $("#"+id)
      var value =$el.val();
      var name = $el.attr("name");
      debugger

      if ($el.is(':checked')) {
        $(this).css("background-color",$("#absent-key").css("background-color"));
        $el.attr("checked", false);
      }
      else {
        $(this).css("background-color",$("#present-key").css("background-color"));
        $el.attr("checked", true);
      }
      var form = $("#attendance_sheet_form");
      $.ajax({
        type: "POST",
        url: $(form).attr("action"),
        data: form.serialize(),
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
