var PWF = window.PWF || {modules:{}};
PWF.modules["payments"] = (function(){
  var BY_CARD="card"
    , PAYPAL="paypal"
  ;

  var form = $("#payment-form")
    , selectedPaymentType = $("input[name='payment[pay_with]']:checked").val()
    , options = $("input[name='payment[pay_with]']")
    , stripeChargeToken = $("#stripe_card_token")
    , hiddenClass = "collapse"
    , fields = $(".credit-card-fields")
  ;

  function initPaymentMethodToggler() {
    options.change(function(event){
      var opt = event.target;

      if(opt.id === "payment_pay_with_paypal"){
        selectedPaymentType = PAYPAL;
        fields.addClass(hiddenClass);
      }else{
        selectedPaymentType = BY_CARD;
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
      stripeChargeToken.val(token);
      form.get(0).submit();
    }

    if (response.error) {
      reeneableSubmitButton();
      showStripeErrors();
    } else {
      saveCharge();
    }
  }


  function stripeTokenEmpty(){
    var val =stripeChargeToken.val();
    return val === undefined || val == null || val === "";

  }

  function initStripeFormSubmit(){

    if(stripeTokenEmpty()){
      form.submit( function(event) {
        // disable the submit button to prevent repeated clicks
        $('.submit-button').attr("disabled", "disabled");

        if(selectedPaymentType ==="card") {
          Stripe.createToken(form,stripeResponseHandler);
          return false;
        }
        else {
          //TODO
          return true;
        }

      });
    }
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


