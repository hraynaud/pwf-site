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
          FactoryBot.create(:student_registration, :previous, parent: parent)
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
        before do
          suppress_log_output
        end

        it "does create new payment" do
          stub_stripe_to_raise_exception
          payment.save
          expect(Payment.count).to eq 0
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
        expect(Stripe::Charge).to_not receive(:create)
      end

      it "does not save the payment" do
        stub_payment_to_be_invalid
        payment.save
        expect(payment).to_not be_persisted
      end
    end
  end

  describe "#affected_registrations" do
    context "for fencing" do
      before do
        stub_stripe
        @parent = FactoryBot.create(:parent, :with_student, count: 2)
        @payment = FactoryBot.create(:stripe_payment, parent: @parent, completed: true)
        @payment.fencing!
        @parent.students.each do |s|
          FactoryBot.create(:student_registration, :confirmed, parent: @parent, student: s, payment: @payment)
        end
        unpaid_student = FactoryBot.create(:student, parent: @parent )
        FactoryBot.create(:student_registration,  parent: @parent, student: unpaid_student)
      end

      context "completed" do
        it "shows paid fencing registrations"  do
          expect(@payment.affected_registrations.count).to eq 2
        end

        it "shows all registrations"  do
          expect(@payment.student_registrations.count).to eq 3
        end
      end

      context "new payment" do
        before do
          @new_payment = FactoryBot.build(:stripe_payment, parent: @parent)
          @new_payment.fencing!
        end

        it "shows un paid fencing registrations"  do
          expect(@new_payment.affected_registrations.count).to eq 1
        end

        it "shows all registrations"  do
          expect(@payment.student_registrations.count).to eq 3
        end
      end
    end

 context "for aep" do
      before do
        stub_stripe
        @parent = FactoryBot.create(:parent, :with_student, count: 2)
        @payment = FactoryBot.create(:stripe_payment, parent: @parent, completed: true)
        @aep_payment = FactoryBot.create(:stripe_payment, parent: @parent, completed: true)
        @payment.aep!
        @parent.students.each do |s|
          reg = FactoryBot.create(:student_registration, :confirmed, parent: @parent, student: s, payment: @payment)
          FactoryBot.create(:aep_registration, :paid, student_registration: reg, payment: @aep_payment)
        end
        unpaid_student = FactoryBot.create(:student, parent: @parent )
        FactoryBot.create(:student_registration,  :confirmed, :with_aep, parent: @parent, student: unpaid_student)
      end

      context "completed" do
        it "shows paid aep registrations"  do
          expect(@aep_payment.affected_registrations.count).to eq 2
        end

        it "shows all registrations"  do
          expect(@aep_payment.student_registrations.count).to eq 3
        end
      end

      context "new payment" do
        before do
          @new_payment = FactoryBot.build(:stripe_payment, parent: @parent)
          @new_payment.aep!
        end

        it "shows un paid aep registrations"  do
          expect(@new_payment.affected_registrations.count).to eq 1
        end

        it "shows all registrations"  do
          expect(@new_payment.student_registrations.count).to eq 3
        end
      end
    end


  end

  def stub_stripe
    allow(Stripe::Charge).to receive(:create).and_return(double(Stripe::Charge).as_null_object)
  end

  def stub_stripe_to_raise_exception
    allow(Stripe::Charge).to receive(:create).and_raise(Stripe::InvalidRequestError.new('error message', 'param'))
  end

  def stub_payment_to_be_invalid
    allow(payment).to receive(:valid?).and_return(false)
  end

end
