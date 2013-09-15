class Grade < ActiveRecord::Base
  belongs_to :report_card
  belongs_to :subject

  validates :subject_id, :report_card_id, :value, :presence =>true
  validates_uniqueness_of :subject_id, scope: [:report_card_id]

  delegate :name, to: :subject, prefix: true


  def normalize_to_hundred_point
     LetterToNumberGradeConverter.by_letter_and_scale(value, report_card.format_cd)
  end


end
