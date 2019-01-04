class Grade < ApplicationRecord

    belongs_to :report_card
    belongs_to :subject

    validates :value, :presence =>true
    validate :value_by_format
    validate :report_card_format_set
    validates_uniqueness_of :subject_id, scope: [:report_card_id]
    delegate :name, to: :subject, prefix: true
    delegate :format_cd, to: :report_card

    before_save  :normalize_to_hundred_point

    def normalize_to_hundred_point
      self.hundred_point = GradeConversionService.getConverter(format_cd).convert(value)
    end

    def score
      hundred_point
    end

    private

    def report_card_format_set
      if report_card.format_cd.nil?
        errors.add(:base, "Please select a grade format before entering a grade")
        return false 
      end
    end

    def value_by_format
      converter_clz = GradeConversionService.getConverter(format_cd)
      unless converter_clz.is_valid?(value)
        errors.add(:base, converter_clz.error_msg)
        return false
      end
    end

end
