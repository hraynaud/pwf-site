#require 'spec_helper'
require 'stripe'

describe Payment do
  describe "#save" do
    context "when the model is valid and stripe payment succeeds" do
      let(:payment){FactoryBot.build(:stripe_payment)}
      let(:parent){mock_model(Parent).as_null_object}

      before do
        allow(payment).to receive(:parent).and_return(parent)
        stub_stripe
      end

      context "And stripe charge is successful" do
        it "creates a new payment" do
          expect{payment.save}.to change{Payment.count}.by 1
        end

        it "applies payments to student registrations when program is fencing " do
          parent = FactoryBot.create(:parent_with_current_student_registrations)

          payment = FactoryBot.build(:stripe_payment, parent: parent, :program => :fencing )
          expect{payment.save;payment.reload}.to change{payment.paid_fencing_registrations.count}.from(0).to(2)
        end

        it "doesn't apply payment if registrations are not pending" do
          parent = FactoryBot.create(:parent_with_current_student_registrations)
          parent.student_registrations.each{|r|r.confirmed_fee_waived!; r.save}
          payment = FactoryBot.build(:stripe_payment, parent: parent, :program => :fencing )
          expect{payment.save;payment.reload}.to_not change{payment.paid_fencing_registrations.count}
        end

        it "doesn't apply payment if registrations are not currrent" do
          parent = FactoryBot.create(:parent)
          FactoryBot.create_list(:student_registration, 2, :previous, parent: parent)
          payment = FactoryBot.build(:stripe_payment, parent: parent, :program => :fencing )
          expect{payment.save; payment.reload}.to_not change{payment.paid_fencing_registrations.count}
        end

        it "applies payments to AEP registrations when program is aep " do
          parent = FactoryBot.create(:parent_with_current_student_registrations)
          regs = parent.student_registrations
          aeps = []
          regs.each do|r|
            r.confirmed_fee_waived!
            r.save
            aeps.push r.create_aep_registration
          end

          payment = FactoryBot.build(:stripe_payment, parent: parent, :program => :aep )
          expect{payment.save;payment.reload}.to change{payment.paid_aep_registrations.count}.from(0).to(2)
        end
      end

      context "when stripe fails" do
        it "does create new payment" do
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
