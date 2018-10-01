describe StudentRegistrationMailer do

  describe 'notify' do
    let(:reg) { FactoryBot.create(:student_registration) } 
    let(:mail) { StudentRegistrationMailer.notify(reg).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eql('Peter Westbrook Foundation Registration')
      expect(mail.to).to eql([reg.parent.email])
      expect(mail.from).to eql(['notifications@peterwestbrook.org'])
      expect(mail.body.encoded).to match("Your registration for #{reg.student_name} has been created.")
    end
  end
end
