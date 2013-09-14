class Grade < ActiveRecord::Base
  belongs_to :report_card
  belongs_to :subject

  validates :subject_id, :report_card, :presence =>true

  def normalize_to_hundred_point
     LetterToNumberGradeConverter.by_letter_and_scale(value, report_card.format_cd)
  end


end
