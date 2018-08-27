#require 'spec_helper'
require 'stripe'

describe Payment do
  describe "#save" do
    context "when the model is valid" do
      let(:payment){FactoryBot.build(:stripe_payment)}
      let(:parent){mock_model(Parent).as_null_object}

      before do
        allow(payment).to receive(:parent).and_return(parent)
        stub_stripe
      end

      context "succeeds" do
        it "saves a new payment" do
          expect{payment.save}.to change{Payment.count}.by 1
        end

        it "should update the student registrations" do
          parent = FactoryBot.create(:parent_with_current_student_registrations)
          payment = FactoryBot.build(:stripe_payment, :parent =>parent, :program => :fencing )
          expect{payment.save;payment.reload}.to change{payment.paid_fencing_registrations.count}.from(0).to(2)
        end

        it "should update the aep registrations" do
          parent = FactoryBot.create(:parent_with_current_student_registrations)
          regs = parent.student_registrations
          aeps = []
          regs.each{|r|aeps.push r.create_aep_registration}
          payment = FactoryBot.build(:stripe_payment, :parent =>parent, :program => :aep )
          expect{payment.save;payment.reload}.to change{payment.paid_aep_registrations.count}.from(0).to(2)
        end
      end

      context "when stripe fails" do
        it "does not save a new payment" do
          stub_stripe_to_raise_exception
          payment.save
          Payment.count.should == 0
        end
      end
    end

    context "when the model is invalid" do

      let(:payment){FactoryBot.build(:stripe_payment)}
      let(:parent){mock_model(Parent).as_null_object}

      before do
        allow(payment).to receive(:parent).and_return(parent)
      end

      it "does not try to create a customer" do
        stub_payment_to_be_invalid
        payment.save
        Stripe::Charge.should_not_receive(:create)
      end

      it "does not save the payment" do
        stub_payment_to_be_invalid
        payment.save
        payment.should_not be_persisted
      end
    end
  end


  describe "#confirm_registrations" do
  end

  def stub_stripe
    allow(Stripe::Charge).to receive(:create).and_return(double(Stripe::Charge).as_null_object)
  end


  def stub_stripe_to_raise_exception
    Stripe::Charge.stub(:create).and_raise(Stripe::InvalidRequestError.new('error message', 'param'))
  end

  def stub_payment_to_be_invalid
    allow(payment).to receive(:valid?).and_return(false)
  end

end
