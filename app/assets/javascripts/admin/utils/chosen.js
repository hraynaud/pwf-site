
ChosenUtils = (function(){

  function initChosen (){
    var el = $('select');
    el.chosen({
      width: getWidth(el)
    })
  }

  function getWidth(el){
     return el.prop('multiple') ? "100%" : "225px";
  }

  function initChosenResultsResizeHack(){
    var currSelect 
      , grandParent
      , originalHeight
    ;

    function getDropDownResults(currSelect){
      return currSelect.siblings('.chosen-container').find(".chosen-results");
    }

    function resizeToFit(currSelect){
      getDropDownResults(currSelect);
      var parent = currSelect.parent('.chosen-wrap')[0];
      //TOOO
    }

    $("select").on('chosen:showing_dropdown', function(){
      resizeToFit($(this));
    }).on('chosen:hiding_dropdown', function(){
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
