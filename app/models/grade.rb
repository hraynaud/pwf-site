class Grade < ActiveRecord::Base

    belongs_to :report_card
    belongs_to :subject

    validates :subject_id, :value, :presence =>true
    validates_uniqueness_of :subject_id, scope: [:report_card_id]

    delegate :name, to: :subject, prefix: true


    def normalize_to_hundred_point
      GradeRanger.convert_to_hundred_point(value, report_card.format_cd)
    end

end
