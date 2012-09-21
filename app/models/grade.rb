class Grade < ActiveRecord::Base
  belongs_to :report_card
  belongs_to :subject

  validates :subject, :report_card, :presence =>true
  validate :should_match_format

  def normalize

  end


  private
  def should_match_format
    1/0
    false
  end
end
