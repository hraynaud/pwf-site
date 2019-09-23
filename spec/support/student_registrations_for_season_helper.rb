module StudentRegistrationsForSeasonHelper
  def setup_students
    @unsaved_registrations = []
    @exclude_list = []
    @confirmed = []
    #12 students
    @students = %W(Zoe Yasmin Xavier Wanda Umia Tynel Lassiter Wavy heighti prev1 prev2 prev3).map do |name|
      FactoryBot.create(:student, first_name: name, last_name: "Fencer")
    end

   # +1 = 13
    create_sibling @students[0]

    # +2 = 15
    @blocked_regs = FactoryBot.create_list(:student, 2 )
  end

  def setup_previous_season_registration

    @students[4..5].each do |s|
      FactoryBot.create(:student_registration,  :confirmed, :previous, student: s)
    end

    @students[9..11].each do |s|
      FactoryBot.create(:student_registration,  :confirmed, :previous, student: s)
    end

    @blocked_regs.each do |s|
      FactoryBot.create(:student_registration,  :confirmed, :previous, student: s)
    end

    setup_previous_waitlist
  end

  def setup_previous_waitlist
    @waitlisters = FactoryBot.create_list(:student_registration, 4, :previous, :wait_list)
    @waitlisters[0..2].each do |r|
      p = r.parent
      p.keep_and_notify_if_waitlisted = true
      p.save
    end
  end

  def setup_marking_periods
    @fall = FactoryBot.create(:marking_period)
    @spring = FactoryBot.create(:marking_period, name: MarkingPeriod::SECOND_SESSION)
  end

  def setup_current_season_registration
    setup_marking_periods
    build_current_confirmed
    build_current_pending
    build_current_wait_list
    build_current_blocked

    @unsaved_registrations.map(&:save)

    @exclude_list << @students[4].parent.id
    setup_aep_registrations
  end

  def build_current_confirmed
    do_current_confirmed_with_both_report_cards
    do_current_confirmed_with_spring_report_card
    do_current_confirmed_with_no_report_card
  end

  def do_current_confirmed_with_no_report_card
    s = @waitlisters[0].student
    @unsaved_registrations << build_current_registration(:confirmed_fee_waived, s)
  end

  def do_current_confirmed_with_spring_report_card
    waived = build_current_registration(:confirmed_fee_waived, @students[6])
    add_current_report_card waived, @spring
    @unsaved_registrations << waived
    @confirmed << waived
  end

  def do_current_confirmed_with_both_report_cards
    @confirmed = @students[0..3].map do |s|
      reg = build_current_registration(:confirmed, s)
      @unsaved_registrations << reg

      add_current_report_card reg,@fall 
      add_current_report_card reg, @spring
      reg
    end
  end

  def build_current_pending
    @students[4..5].each do |s|
      reg = build_current_registration(:pending, s)
      allow(reg).to receive(:requires_last_years_report_card?) {false}
      @unsaved_registrations << reg
    end

    @unsaved_registrations << build_current_registration(:pending, @students[8])
  end

  def build_current_blocked
    @blocked_regs.each do |reg|
      blocked = build_current_registration(:confirmed, reg)
      @unsaved_registrations << blocked
    end
  end

  def build_current_wait_list
    @unsaved_registrations << build_current_registration(:wait_list, @students[7])
  end

  def create_sibling sibling
    @students <<  FactoryBot.create(:student, first_name: "Same", last_name: "Parent", parent: sibling.parent )
  end

  def setup_aep_registrations
    FactoryBot.create(:aep_registration, :paid, student_registration: @confirmed[0])
  end

  def build_current_registration status, student
    FactoryBot.build(:student_registration, status, student: student)
  end

  def add_current_report_card registration, marking_period
    FactoryBot.create(:report_card, :with_transcript, 
                      student_registration:  registration,
                      marking_period: marking_period, academic_year:  Season.current.academic_year)
  end

end
