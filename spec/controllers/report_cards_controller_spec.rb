RSpec.describe ReportCardsController do
include ActiveJob::TestHelper
  after(:each) do
    ActiveJob::Base.queue_adapter.enqueued_jobs =[]
  end

  before :all do
    FactoryBot.create(:marking_period)
  end

  before(:each) do
    @parent = FactoryBot.create(:parent,:valid) 
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(@parent)
    session[:reg_complete]=true
    @reg = FactoryBot.create(:student_registration, :confirmed, parent: @parent)
  end


  describe "post create" do
    context "valid" do
      let(:params){build_params(:valid)}

      it "succeeds" do
        expect( post :create,  params: params).to redirect_to(report_cards_path)
      end

      it "sends email" do
        post :create,  params: params
        expect(ActionMailer::DeliveryJob).to have_been_enqueued.with('ReportCardMailer', 'uploaded', 'deliver_now',ReportCard.first).on_queue('mailers')
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


  describe "put update" do
    before do
      @card = FactoryBot.create(:report_card,:with_transcript,
                                student_registration: @reg)
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
        @params[:report_card] = @params[:report_card].except!(:transcript_pages)
        expect{put :update,  params: @params}.to change{ActiveStorage::Blob.count}.by(0)
      end
    end

    context "invalid" do
      before do
        @params[:report_card][:marking_period_id] =""
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

  def build_params type, file_name = "transcript1.pdf"
    {report_card: send(type, file_name).merge({student_registration_id: @reg.id, marking_period_id: 1})}
  end

  def valid file_name
    FactoryBot.attributes_for(:report_card).merge transcript_params(file_name)
  end

  def invalid file_name = nil
    FactoryBot.attributes_for(:report_card, :invalid)
  end

  def update_params card
    new_params = {id: card.id }.merge build_params(:valid, "transcript2.pdf")
    new_params
  end

  def transcript_params file_name
    {transcript_pages:  [AttachmentHelper.pdf(file_name)]}
  end

end
