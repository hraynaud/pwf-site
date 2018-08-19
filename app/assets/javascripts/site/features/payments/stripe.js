
PWF.StripePaymentHandler = function(form){
  var form = form
    , stripeChargeToken = $("#stripe_card_token")
    , submitButton = form.find("input[type=submit]")
  ;

  function stripeResponseHandler(status, response) {

    var token = response.id; // token contains id, last4, and card type

    function reeneableSubmitButton(){
      submitButton.removeAttr("disabled");
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
    var val = stripeChargeToken.val();
    return val === undefined || val == null || val === "";

  }

  function initStripeFormSubmit(){

    if(stripeTokenEmpty()){
      form.submit( function(event) {
        // disable the submit button to prevent repeated clicks
        submitButton.attr("disabled", "disabled");

        Stripe.createToken(form,stripeResponseHandler);
        return false;
      });
    }
  }

  function init(){
    try {
      Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
      initStripeFormSubmit()
    }
    catch(e){
    }
  }

  return {
    init: init
  };

}


