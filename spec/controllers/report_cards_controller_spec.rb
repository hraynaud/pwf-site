RSpec.describe ReportCardsController do

  after(:each) do
    ActiveJob::Base.queue_adapter.enqueued_jobs =[]
  end

  before(:each) do
    @reg = FactoryBot.create(:student_registration)
    sign_in(@reg.parent)
  end

  describe "GET index" do
    it "assigns @report_cards" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "post create" do
    context "valid" do
      let(:params){build_params(:valid)}

      it "assigns succeeds" do
        expect( post :create,  params: params).to redirect_to(report_cards_path)
      end

      it "sends email" do
        post :create,  params: params
        expect(ActionMailer::DeliveryJob).to have_been_enqueued.with('ReportCardMailer', 'uploaded', 'deliver_now',ReportCard.first)
      end

      it "creates attachment" do
        expect{post :create,  params: params}.to change{ActiveStorage::Blob.count}.by(1)
      end
    end

    context "invalid" do
      let(:params){build_params(:invalid)}
      it "doesn't send email" do
        post :create,  params: params
        expect(ActionMailer::DeliveryJob).to_not have_been_enqueued.with('ReportCardMailer', 'uploaded', 'deliver_now',ReportCard.first)
      end

      it "doesn't send email" do
        post :create,  params: params
        expect(ActionMailer::DeliveryJob).to_not have_been_enqueued.with('ReportCardMailer', 'uploaded', 'deliver_now',ReportCard.first)
      end

      it "doesn't Create record" do
        expect{post :create,  params: params}.to change{ReportCard.count}.by(0)
      end

      it "doesn't Create attachment" do
        expect{post :create,  params: params}.to change{ActiveStorage::Blob.count}.by(0)
      end
    end
  end

  private

  def build_params variant
    {report_card: send(variant).merge({student_registration_id: @reg.id})}
  end

  def valid
    FactoryBot.attributes_for(:report_card, :with_transcript)
  end

  def invalid
    FactoryBot.attributes_for(:report_card, :invalid)
  end
end
