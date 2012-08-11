require 'spec_helper'
require 'stripe'
require 'paypal'

describe Payment do

  describe "#save_with_stripe_payment" do
    let(:payment){FactoryGirl.build(:stripe_payment)}
    context "when the model is valid" do
      context "when stripe billing succeeds" do
        it "saves a new payment" do
          payment.save_with_stripe!
          Payment.count.should == 1
        end
      end

      context "when stripe billing fails" do
        it "does not save a new payment" do
          stub_stripe_to_raise_exception
          payment.save_with_stripe!
          Payment.count.should == 0
        end
      end
    end

    context "when the model is invalid" do
      it "does not try to create a customer" do
        stub_payment_to_be_invalid
        payment.save_with_stripe!
        Stripe::Charge.should_not_receive(:create)
      end

      it "does not save the payment" do
        stub_payment_to_be_invalid
        payment.save_with_stripe!
        payment.should_not be_persisted
      end
    end
  end

  context "PayPal payments" do

    let(:payment){FactoryGirl.build(:paypal_payment)}
    let(:paypal_client){mock(Paypal::Express::Request).as_null_object}
    let(:valid_paypal_response){mock(Paypal::Express::Response).as_null_object}
    let(:customer){FactoryGirl.build(:customer)}

    before(:each) do
      payment.stub(:paypal_client).and_return(paypal_client)
      paypal_client.stub(:setup).and_return(valid_paypal_response)
      valid_paypal_response.stub(:token).and_return("123456xyz-abc")
    end

    describe "#save_with_paypal!" do

      context "when paypal response is valid" do
        it "saves a new payment" do
          payment.save_with_paypal!("success_path", "failure_path")
          payment.should be_persisted
          Payment.count.should == 1
        end
      end

      context "when paypal response throws exception" do
        it "does not save a new payment" do
          paypal_client.stub(:setup).and_raise(Paypal::Exception::APIError.new({}))

          payment.save_with_paypal!("some", "url")
          payment.should_not be_persisted
          Payment.count.should == 0
        end
      end
    end

    describe "#paypal_complete!" do
      before(:each) do
        payment.stub(:recurring?).and_return(false)
        payment.stub(:token).and_return("abc-123")
        paypal_client.stub(:checkout!).and_return(valid_paypal_response)
        valid_paypal_response.stub_chain("payment_info.first.transaction_id").and_return("123")
      end

      context "when paypal response is valid" do
        it "it creates a customer and updates payment" do
          payment.paypal_complete!()
          payment.completed?.should be_true
        end

      end
    end
  end

  describe "#confirm_registrations" do
    it "should update the student registrations" do
      payment = FactoryGirl.build(:completed_payment)
      payment.parent.current_unpaid_pending_registrations.count.should == 2;
      payment.run_callbacks(:save)
      payment.student_registrations.each do |reg|
        reg.payment_id.should == payment.id
      end
      payment.parent.current_unpaid_pending_registrations.count.should == 0;
    end
  end

  def stub_stripe
    Stripe::Charge.stub(:create).and_return(mock(Stripe::Charge))
  end

  def stub_stripe
    Stripe::Charge.stub(:create).and_return(mock(Stripe::Charge))
  end

  def stub_paypal_to_raise_exception
    Stripe::Charge.stub(:create).and_raise(Stripe::InvalidRequestError.new('error message', 'param'))
  end

  def stub_stripe_to_raise_exception
    Stripe::Charge.stub(:create).and_raise(Stripe::InvalidRequestError.new('error message', 'param'))
  end

  def stub_payment_to_be_invalid
    payment.stub(:valid?).and_return(false)
  end

end
