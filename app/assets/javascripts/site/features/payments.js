
var PWF = window.PWF || {modules:{}};
PWF.modules["payments"] = (function(){

  var form = $("#payment-form")
    , paymentHandler
  ;

  function init(){
    paymentHandler = new PWF.StripePaymentHandler(form);
    paymentHandler.init();
  }

  return {
    init: init
  };

}());


