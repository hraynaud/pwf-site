
var PWF = window.PWF || {modules:{}};
PWF.modules["payments"] = (function(){

  var form = $("#payment-form")
    , selectedPaymentType = $("input[name='payment[pay_with]']:checked").val()
    , options = $("input[name='payment[pay_with]']")
    , hiddenClass = "collapse"
    , fields = $(".credit-card-fields")
    , submitButton = $("#btn-submit")
    , paymentHandler
  ;

  function initPaymentMethodToggler() {
    options.change(function(event){
      var opt = event.target;

      if(opt.id === "payment_pay_with_paypal"){
        fields.addClass(hiddenClass);
      }else{
        fields.removeClass(hiddenClass);
        paymentHandler = new PWF.StripePaymentHandler(form);
        paymentHandler.init();
      }
    });
  }

  function init(){
    initPaymentMethodToggler();
  }

  return {
    init: init
  };

}());


