module GradeConversionService

  RANGES ={
    :four_point => 0..4,  
    :hundred_point => 0..100, 
    :a_plus_to_f =>%w(A+ A- A B+ B B- C+ C C- D+ D D- F),
  }

  VALIDATIONS ={
    four_point: [
      {type:'number', range:[0,4]}, 
      {message: "Must between 0.0 and 4.0"}
    ].to_json,

    hundred_point: [
      {type:'number', range:[1,100]}
    ].to_json,

    a_plus_to_f: [{
      inlist: %w(A+ A- A B+ B B- C+ C C- D+ D D- F).join(",")
    },
    {
      message: "Invalid grade, only  'A+, A-, A, B+, B,  B-, C+, C, C-, D+, D, D- or F'"
    }].to_json,

  }

  FOUR_POINT_CONVERTION_TABLE = {
    4.5 => 100,
    4.4 => 99,
    4.3 => 98,
    4.2 => 97,
    4.1 => 96,
    4 => 95,
    3.9 => 94,
    3.8 => 93,
    3.7 => 92,
    3.6 => 91,
    3.5 => 90,
    3.4 => 89,
    3.3 => 88,
    3.2 => 87,
    3 => 85,
    2.9 => 84,
    2.8 => 83,
    2.7 => 82,
    2.6 => 81,
    2.5 => 80,
    2.4 => 79,
    2.3 => 78,
    2.2 => 77,
    2.1 => 76,
    2 => 75,
    1.9 => 74,
    1.8 => 73,
    1.7 => 72,
    1.6 => 71,
    1.5 => 70,
    1.4 => 69,
    1.3 => 68,
    1.2 => 67,
    1.1 => 66,
    1 => 65,
    0.9 => 64,
    0.8 => 63,
    0.7 => 62,
    0.6 => 61,
    0.5 => 60,
    0.4 => 59,
    0.3 => 58,
    0.2 => 57,
    0.1 => 56,
    0 => 57,
  }

  FORMATS = RANGES.keys

  LETTER_CONVERSION_TABLE = {
    'A+' => 99,
    'A' => 95.5,
    'A-' => 91.5,
    'B+' => 88,
    'B' => 85,
    'B-' => 81.5,
    'C+' => 77.5,
    'C' => 74,
    'C-' => 71,
    'D+' => 68,
    'D' => 64.5,
    'D-' => 61,
    'F' => 57.4,
  }

  class FourPointConverter
    def self.index 
      0
    end

    def self.convert(value)
      table = FOUR_POINT_CONVERTION_TABLE
      table[
        table.keys.min_by { |x| (value.to_f - x.to_f).abs}
      ]
    end

  end

  class LetterConverter

    def self.index 
      2
    end
    VALUES = %w(A+ A- A B+ B B- C+ C C- D+ D D- F).join(",")

    def self.convert value
      LETTER_CONVERSION_TABLE[value]
    end

    def self.is_valid? value
      VALUES.include? value
    end

    def self.error_msg
      "invalid letter grade, only 'A+, A-, A, B+, B,  B-, C+, C, C-, D+, D, D- or F'"
    end
  end

  class HundredPointConverter
    def self.index 
      1
    end
    VALUES = 1..100

    def self.convert value
      value
    end

    def self.is_valid? value
      VALUES.include? value.to_i
    end

    def self.error_msg
      "invalid Number Grade, only numbers from 1 to 100 allowed."
    end
  end


  CONVERTERS = {0 => FourPointConverter, 1 => HundredPointConverter, 2 => LetterConverter}

  def self.getConverter format
    CONVERTERS[format]
  end

  def self.convert_to_hundred_point(value, format)
    converter.convert(value)
  end

  def self.description_for format
    "#{format.to_s.titleize}"
  end


  def self.for_select
    FORMATS.each_with_index.map{|f,i| [description_for(f), i]}
  end
end
