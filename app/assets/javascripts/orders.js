$(document).ready(function() {

  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
  setupForm();

  $("#payment-form").submit(function(event) {
    // disable the submit button to prevent repeated clicks
    var $form = $(this);

    $('.submit-button').attr("disabled", "disabled");

    if( $("input[name='payment[pay_with]']:checked").val()=="card") {
      Stripe.createToken($form,stripeResponseHandler);
        return false;
    }
    else {
      //TODO
      return true
    }

  });

  function setupForm() {
    $('#payment_pay_with_paypal').change(function(event){
      $('#billing_fields').hide();
      return true
    } );

    $('#payment_pay_with_card').change(function(event) {
      $('#billing_fields').show();
      return true
    } );
  }

  function stripeResponseHandler(status, response) {

    if (response.error) {
      // re-enable the submit button
      $('.submit-button').removeAttr("disabled");
      // show the errors on the form
      $("#stripe_error").html(response.error.message);
    } else {
      var form$ = $("#payment-form");
      // token contains id, last4, and card type
      var token = response['id'];
      // insert the token into the form so it gets submitted to the server
      $("#processing").html("Processing ...");
      $("#stripe_card_token").val(token)
      // and submit
      form$.get(0).submit();
    }
  }

});


