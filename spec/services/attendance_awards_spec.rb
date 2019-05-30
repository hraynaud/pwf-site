describe AttendanceAwards do
  before do

    students = %W(Zoe Yasmin Xavier Wanda Umia Tynel).map do |name|
      FactoryBot.create(:student, first_name: name, last_name: "Fencer")
    end

    sessions = [9.weeks.ago,8.weeks.ago,7.weeks.ago, 6.weeks.ago, 5.weeks.ago, 4.weeks.ago, 3.weeks.ago, 2.weeks.ago, 1.week.ago, Date.today  ].map do |d|
      FactoryBot.create(:attendance_sheet, session_date: d.to_date, season: Season.current)
    end

    @regs = students.map do |s|
      FactoryBot.create(:student_registration, :confirmed, student: s)
    end

    FactoryBot.create(:attendance, student_registration: @regs[0], attendance_sheet: sessions[0], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[1], attendance_sheet: sessions[0], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[2], attendance_sheet: sessions[0], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[3], attendance_sheet: sessions[0], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[4], attendance_sheet: sessions[0], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[5], attendance_sheet: sessions[0], attended: true)

    FactoryBot.create(:attendance, student_registration: @regs[0], attendance_sheet: sessions[1], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[1], attendance_sheet: sessions[1], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[2], attendance_sheet: sessions[1], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[3], attendance_sheet: sessions[1], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[4], attendance_sheet: sessions[1], attended: true)

    FactoryBot.create(:attendance, student_registration: @regs[0], attendance_sheet: sessions[2], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[2], attendance_sheet: sessions[2], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[4], attendance_sheet: sessions[2], attended: true)

    FactoryBot.create(:attendance, student_registration: @regs[0], attendance_sheet: sessions[3], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[1], attendance_sheet: sessions[3], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[3], attendance_sheet: sessions[3], attended: true)

    FactoryBot.create(:attendance, student_registration: @regs[0], attendance_sheet: sessions[4], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[3], attendance_sheet: sessions[4], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[4], attendance_sheet: sessions[4], attended: true)

    FactoryBot.create(:attendance, student_registration: @regs[0], attendance_sheet: sessions[5], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[3], attendance_sheet: sessions[5], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[4], attendance_sheet: sessions[5], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[5], attendance_sheet: sessions[5], attended: true)

    FactoryBot.create(:attendance, student_registration: @regs[0], attendance_sheet: sessions[6], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[2], attendance_sheet: sessions[6], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[3], attendance_sheet: sessions[6], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[4], attendance_sheet: sessions[6], attended: true)

    FactoryBot.create(:attendance, student_registration: @regs[0], attendance_sheet: sessions[7], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[1], attendance_sheet: sessions[7], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[4], attendance_sheet: sessions[7], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[5], attendance_sheet: sessions[7], attended: true)

    FactoryBot.create(:attendance, student_registration: @regs[0], attendance_sheet: sessions[8], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[1], attendance_sheet: sessions[8], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[2], attendance_sheet: sessions[8], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[3], attendance_sheet: sessions[8], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[4], attendance_sheet: sessions[8], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[5], attendance_sheet: sessions[8], attended: true)

    FactoryBot.create(:attendance, student_registration: @regs[0], attendance_sheet: sessions[9], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[1], attendance_sheet: sessions[9], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[3], attendance_sheet: sessions[9], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[4], attendance_sheet: sessions[9], attended: true)
    FactoryBot.create(:attendance, student_registration: @regs[5], attendance_sheet: sessions[9], attended: true)

    # Summary
    # -------
    # Zoe: 10
    # Yasmin: 6
    # Xavier: 5
    # Wanda: 8
    # Umia: 9
    # Tynel: 5
  end

  describe ".hoodies" do

    it "returns the subset of students who meet the hoodie criteria " do
      @hoodie_students = AttendanceAwards.hoodies(confirmed_students, {"q" =>{"h_eq" =>70.0, "asof_eq" => Date.today.to_s}})
      expect(@hoodie_students.map(&:student_name)).to eq(["Zoe Fencer", "Wanda Fencer", "Umia Fencer"])
    end
  end

  describe ".t_shirts" do
    it "returns the subset of students who meet the t-shirt criteria " do
      students = AttendanceAwards.t_shirts(confirmed_students, {"q" =>{"h_eq" =>70.0, "t_eq" => 60.0, "asof_eq" => Date.today.to_s}})
      expect(students.map(&:student_name)).to eq([
        "Yasmin Fencer" ])
    end
  end

  describe ".no_award" do
    it "returns the subset of students who meet the t-shirt criteria " do
      students = AttendanceAwards.no_award(confirmed_students, {"q" =>{"t_eq" => 60.0, "asof_eq" => Date.today.to_s}})
      expect(students.map(&:student_name)).to eq(["Xavier Fencer", "Tynel Fencer"])
    end
  end

  def confirmed_students
    StudentRegistration.current.confirmed
  end

  def names registrations
    registrations.map(&:student_name)
  end

end
