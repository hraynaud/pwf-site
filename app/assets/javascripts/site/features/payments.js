var PWF = window.PWF || {modules:{}};
PWF.modules["payments"] = (function(){

  var form = $("#payment-form")
    , selectedPaymentType = $("input[name='payment[pay_with]']:checked")
    , options = $("input[name='payment[pay_with]']")
    , hiddenClass = "collapse"
  ;

  function initPaymentMethodToggler() {
    var fields = $(".credit-card-fields");

    options.change(function(event){
      var opt = event.target;

      if(opt.id === "payment_pay_with_paypal"){
        fields.addClass(hiddenClass);
      }else{
        fields.removeClass(hiddenClass);
      }
    });
  }

  function stripeResponseHandler(status, response) {

    var token = response.id; // token contains id, last4, and card type

    function reeneableSubmitButton(){
      $('.submit-button').removeAttr("disabled");
    }

    function showStripeErrors(){
      $("#stripe_error").html(response.error.message);
    }

    function showProcessing(){
      $("#processing").html("Processing ...");
    }

    function saveCharge(){
      showProcessing();
      $("#stripe_card_token").val(token);
      form.get(0).submit();
    }

    if (response.error) {
      reeneableSubmitButton();
      showStripeErrors();
    } else {
      saveCharge();
    }
  }

  function initStripeFormSubmit(){
    form.submit( function(event) {
      // disable the submit button to prevent repeated clicks
      $('.submit-button').attr("disabled", "disabled");

      if(selectedPaymentType.val()=="card") {

        debugger
        Stripe.createToken(form,stripeResponseHandler);
        return false;
      }
      else {
        //TODO
        return true;
      }

    });
  }

  function init(){
    try
    {
      Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
      initPaymentMethodToggler();
      initStripeFormSubmit()
    }
    catch(e){
    }
  }

  return {
    init: init
  };

}());


