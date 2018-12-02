describe Attendance do
  let(:sheet){FactoryBot.create(:attendance_sheet)}

  it "should be valid" do
    attendance = FactoryBot.create(:attendance, attendance_sheet: sheet)
    expect(attendance).to be_valid
  end

  it "is invalid if attendance exist already for student and date combo" do
    reg = FactoryBot.create(:student_registration)
    FactoryBot.create(:attendance, attendance_sheet: sheet, student_registration: reg)
    attendance2 = FactoryBot.build(:attendance, attendance_sheet: sheet, student_registration: reg)
    expect(attendance2).to be_invalid
  end

  it "is invalid if attendance exist already for student and date combo" do
    reg = FactoryBot.create(:student_registration)
    FactoryBot.create(:attendance, attendance_sheet: sheet, student_registration: reg)
    attendance2 = FactoryBot.build(:attendance, attendance_sheet: sheet, student_registration: reg)
    expect(attendance2).to be_invalid
  end
end


