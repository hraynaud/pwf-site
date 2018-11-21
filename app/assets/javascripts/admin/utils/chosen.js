
ChosenUtils = (function(){

 function initChosen (){
    $('select').chosen({
      width: '225px'
    })
  }

  function initChosenResultsResizeHack(){
    var currSelect 
      , grandParent
      , originalHeight
    ;

    function getDropDownResults(){
      return currSelect.siblings('.chosen-container').find(".chosen-results");
    }

    function resizeToFit(){
      getDropDownResults().height("100px");
      grandParent.height("250px");
    }

    $(".filter_form select").on('chosen:showing_dropdown', function(){
      currSelect = $(this);
      grandParent = currSelect.parent().parent();
      originalHeight = grandParent.height();
      resizeToFit();
    }).on('chosen:hiding_dropdown', function(){
      grandParent.height(originalHeight);
    })
  }

  function init(){
    initChosen();
    initChosenResultsResizeHack();
  }
  return {
   init: init
  };

})()
