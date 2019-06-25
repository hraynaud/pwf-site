# spec/jobs/send_new_user_invitation_job_spec.rb
require "rails_helper"
require "json"
include StudentRegistrationsForSeasonHelper
describe MailNotificationJob do
    before :all do
      setup_students
      setup_previous_season_registration
    end

    before :each do
      setup_current_season_registration
    end

  describe "#perform" do
    it "mails only confirmed students" do
      allow(GeneralMailer).to receive_message_chain(:notify, :deliver_later)
      params = {"mailing_list"=>"confirmed", "subject"=>"this is a test", "message"=>"<p>asdfasdfsa</p>"}.to_json
      described_class.new.perform(params)
      expect(GeneralMailer).to have_received(:notify).exactly(5).times
    end


    it "mails pending students" do
      allow(GeneralMailer).to receive_message_chain(:notify, :deliver_later)
      params = {"mailing_list"=>"pending", "subject"=>"this is a test", "message"=>"<p>asdfasdfsa</p>"}.to_json
      described_class.new.perform(params)
      expect(GeneralMailer).to have_received(:notify).exactly(3).times
    end

    it "mails wait listed students" do
      allow(GeneralMailer).to receive_message_chain(:notify, :deliver_later)
      params = {"mailing_list"=>"wait_listed", "subject"=>"this is a test", "message"=>"<p>asdfasdfsa</p>"}.to_json
      described_class.new.perform(params)
      expect(GeneralMailer).to have_received(:notify).exactly(1).times
    end


  end

end
