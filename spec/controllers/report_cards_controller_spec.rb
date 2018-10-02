RSpec.describe ReportCardsController do

  after(:each) do
    ActiveJob::Base.queue_adapter.enqueued_jobs =[]
  end

  before(:each) do
    @reg = FactoryBot.create(:student_registration)
    sign_in(@reg.parent)
  end


  describe "post create" do
    context "valid" do
      let(:params){build_params(:valid)}

      it "succeeds" do
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


  describe "post update" do
    before do
      @card = FactoryBot.create(:report_card, :with_transcript, student_registration: @reg)
      @params = update_params(@card)
    end

    context "valid" do
      it " succeeds" do
        expect( put :update,  params: @params).to redirect_to(report_cards_path)
      end

      it "sends email" do
        put :update,  params: @params
        expect(ActionMailer::DeliveryJob).to have_been_enqueued.with('ReportCardMailer', 'uploaded', 'deliver_now',ReportCard.first)
      end

      it "creates attachment" do
        expect{put :update,  params: @params}.to change{ActiveStorage::Blob.count}.by(1)
      end

      it "doesn't create attachment" do
        @params[:report_card] = @params[:report_card].except!(:transcript)
        expect{put :update,  params: @params}.to change{ActiveStorage::Blob.count}.by(0)
      end
    end

    context "invalid" do
      before do
        @params[:report_card][:marking_period]=""
      end

      it "doesn't send email" do
        put :update,  params: @params
        expect(ActionMailer::DeliveryJob).to_not have_been_enqueued.with('ReportCardMailer', 'uploaded', 'deliver_now',ReportCard.first)
      end

      it "doesn't update attachment" do
        put :update,  params: @params
        expect(ActiveStorage::PurgeJob).to_not have_been_enqueued.with('ReportCardMailer', 'uploaded', 'deliver_now',ReportCard.first)
      end

      it "doesn't update record" do
        expect{put :update,  params: @params}.to_not change{@card.updated_at}
      end

      it "doesn't Create attachment" do
        expect{put :update,  params: @params}.to change{ActiveStorage::Blob.count}.by(0)
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

  def update_params card
    {id: card.id}.merge build_params(:valid)
  end

end
