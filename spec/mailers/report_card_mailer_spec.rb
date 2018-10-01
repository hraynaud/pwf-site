describe ReportCardMailer do
  describe 'uploaded' do
    let(:card) { FactoryBot.create(:report_card) } 
    let(:mail) { ReportCardMailer.uploaded(card).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eql('New report card uploaded')
      expect(mail.to).to eql(['report_card_uploads@peterwestbrook.org'])
      expect(mail.from).to eql(['notifications@peterwestbrook.org'])
      expect(mail.body.encoded).to match("Hi AEP administrator. A new report card has been uploaded for your review")
    end
  end
end
