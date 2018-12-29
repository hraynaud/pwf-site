RSpec.describe StudentRegistrationsController do
  before(:each) do
    @parent = FactoryBot.create(:parent, :valid, :with_student)
    @student = @parent.students.first
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(@parent)
    session[:reg_complete]=true
  end

  after(:each) do
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
  end

  describe "get new" do
    context "can register is false" do
      before do

        allow(StudentRegistrationAuthorizer).to receive(:can_register?).and_return(OpenStruct.new(:answer => false, :message =>"New student enrollment is closed"))
      end 
      it "redirects to student path" do
        expect( get :new,  params: {student_id: @student.id}).to redirect_to(student_path(@student))
      end 
    end

    context "can register is true" do
      before do
        allow(StudentRegistrationAuthorizer).to receive(:can_register?).and_return(OpenStruct.new(:answer=> true))
      end 
      it "redirects to student path" do
          get :new,  params: {student_id: @student.id}
          expect(response.status).to eq(200)
      end 
    end
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


  describe "put update" do
    before do
      @reg = FactoryBot.create(:student_registration,  student: @student, parent: @parent)
      @params = update_params(@reg)
    end

    context "valid" do
      it " succeeds" do
        expect( put :update,  params: @params).to redirect_to(dashboard_path)
      end
    end

    context "invalid" do
      before do
        @params[:student_registration][:grade]=""
      end

      it "doesn't update record" do
        expect{put :update,  params: @params}.to_not change{@reg.updated_at}
      end
    end
  end

  describe "get edit" do
    it "prevents parents from seeing students who are not their own" do
      @parent2 = FactoryBot.create(:parent, :with_student)
      @student2 = @parent2.students.first
      student_reg = FactoryBot.create(:student_registration, student: @student2)
      expect( get :edit,  params:{id: student_reg.id} ).to redirect_to(dashboard_path) 
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

  def update_params reg
    {id: reg.id}.merge build_params(:valid)
  end

end



