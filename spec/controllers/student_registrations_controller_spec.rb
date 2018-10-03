RSpec.describe StudentRegistrationsController do
  before(:each) do
    @parent = FactoryBot.create(:parent, :with_student)
    @student = @parent.students.first
    sign_in @parent
  end

  after(:each) do
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
  end

  describe "post create" do
    context "when valid" do
      let(:params){build_params(:valid)}

      it "succeeds" do
        expect( post :create,  params: params).to redirect_to(dashboard_path)
      end

      it "triggers the wait list when over capacity" do
        expect(WaitListService).to receive(:activate_if_enrollment_limit_reached).once
        post :create,  params: params
      end

      it "sends email" do
        post :create,  params: params
        expect(ActionMailer::DeliveryJob).to have_been_enqueued.with('StudentRegistrationMailer', 'notify', 'deliver_now',StudentRegistration.last)
      end
    end

    context "when invalid" do
      let(:params){build_params(:invalid)}

      it "Doesn't trigger the wait list service" do
        expect(WaitListService).to_not receive(:activate_if_enrollment_limit_reached)
        post :create,  params: params
      end

      it "doesn't send email" do
        post :create,  params: params
        expect(ActionMailer::DeliveryJob).to_not have_been_enqueued.with('StudentRegistrationMailer', 'notify', 'deliver_now',StudentRegistration.last)
      end
    end

  end

  private

  def build_params variant
    {student_registration: send(variant).merge({student_id: @student.id, season_id: Season.current.id})}
  end

  def valid
    FactoryBot.attributes_for(:student_registration)
  end

  def invalid
    FactoryBot.attributes_for(:student_registration, :invalid)
  end


end



