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

  private

  def has_transcript? card
    !card.first.nil? && card.first.transcript.attached?
  end

  def first_report_card
    report_by_sesssion MarkingPeriod.first_session
  end

  def second_report_card
    report_by_sesssion MarkingPeriod.second_session
  end

  def report_by_sesssion period
    student.report_cards.by_year_and_marking_period(school_year, period)
  end

end
