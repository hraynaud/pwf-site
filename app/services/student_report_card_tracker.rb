class StudentReportCardTracker
  attr_reader :student, :school_year

  def initialize student, school_year
    @student = student
    @school_year = school_year
  end

  def has_uploaded_first_and_second_report_card_for_season?
    first_session_transcript_provided? && second_session_transcript_provided?
  end

  def has_not_uploaded_first_and_second_report_card_for_season?
    !has_uploaded_first_and_second_report_card_for_season?
  end
  
  def first_session_transcript_provided?
    has_transcript?(first_report_card)
  end

  def second_session_transcript_provided?
    has_transcript?(second_report_card)
  end

  def unblock_current_registration
    if has_uploaded_first_and_second_report_card_for_season?
      student.current_registration.pending!
      student.current_registration.save
    end
  end

  private

  def has_transcript? card
    !card.first.nil? && card.first.transcript.attached?
  end

  def first_report_card
    report_by_session MarkingPeriod.first_session
  end

  def second_report_card
    report_by_session MarkingPeriod.second_session
  end

  def report_by_session period
    student.report_cards.by_year_and_marking_period(school_year, period)
  end

end
