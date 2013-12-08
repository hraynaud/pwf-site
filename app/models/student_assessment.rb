class StudentAssessment < ActiveRecord::Base
  attr_accessible :aep_registration_id, :pre_test_math_score, :pre_test_reading_score, :pre_test_writing_score,
    :post_test_math_score, :post_test_reading_score, :post_test_writing_score

  belongs_to :aep_registration
  has_one :student, through: :aep_registration
  has_one :season, through: :aep_registration
  belongs_to :pre_assessment, class_name: Assessment, foreign_key: :pre_test_id
  belongs_to :post_assessment, class_name: Assessment, foreign_key: :post_test_id
  delegate :name, to: :student, prefix: true
  delegate :term, to: :season

  def pre_test_overall_score
    overall_score "pre"
  end

  def post_test_overall_score
    overall_score "post"
  end

  private

  def  overall_score moment
    return nil if send("#{moment}_assessment").nil?
    fields =["#{moment}_test_math_score", "#{moment}_test_reading_score", "#{moment}_test_writing_score"].map do |field|
      send(field) || 0
    end
    fields.inject(0){|sum,val| sum += val; sum}
  end


end
