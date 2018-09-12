
describe AepRegistration, :focus => :aep_fee do
  it "is invalid if student_registration is not confirmed" do
    student_reg =FactoryBot.create(:student_registration, status_cd: 0)
    expect{FactoryBot.create(:aep_registration, student_registration: student_reg)}.to raise_error(ActiveRecord::RecordInvalid,'Validation failed: Cannot register unconfirmed student for AEP')
  end

  it "is valid if student_registration is confirmed" do
    reg = FactoryBot.create(:student_registration,  :confirmed)
    expect{FactoryBot.create(:aep_registration, student_registration: reg)}.to change{AepRegistration.count}.by(1)
  end


end
