class Grade < ApplicationRecord

    belongs_to :report_card
    belongs_to :subject

    validates :subject_id, :value, :presence =>true
    validates_uniqueness_of :subject_id, scope: [:report_card_id]
    delegate :name, to: :subject, prefix: true

    before_save :normalize_to_hundred_point


    def normalize_to_hundred_point
      self.hundred_point = GradeConversionService.convert_to_hundred_point(value, report_card.format_cd) if value && report_card.try(:format_cd)
    end

end
