class GradeRanger
  RANGES ={:four_point => 1..4,  
    :hundred_point => 0..100, 
    :a_plus_to_f =>%w(A+ A- A B+ B B- C+ C C- D+ D D- F),
  :five_point => 1..5}
  VALIDATIONS ={
    four_point: [
      {type:'number', range:[1,4]}, 
      {message: "Must between 1.0 and 4.0"}
    ].to_json,

    hundred_point: [
      {type:'number', range:[1,100]}
    ].to_json,

    a_plus_to_f: [
      {inlist: %w(A+ A- A B+ B B- C+ C C- D+ D D- F).join(",")},
      {message: "Invalid grade, only  'A+, A-, A, B+, B,  B-, C+, C, C-, D+, D, D- or F'"}
    ].to_json,

    five_point: [
      {type:'number', range:[1,5]}, 
      {message: "Must between 1.0 and 5.0"}
    ].to_json,
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
    3.1 => 86,
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

  FIVE_POINT_CONVERTION_TABLE = {
    5.0 =>100,
    4.9 =>99,
    4.8 =>98,
    4.7 =>97,
    4.6 =>96,
    4.5 =>95,
    4.4 =>94,
    4.3 =>93,
    4.2 =>92,
    4.1 =>91,
    4.0 =>90,
    3.9 =>89,
    3.8 =>88,
    3.7 =>87,
    3.6 =>86,
    3.5 =>85,
    3.4 =>84,
    3.3 =>83,
    3.2 =>82,
    3.1 =>81,
    3.0 =>80,
    2.9 =>79,
    2.8 =>78,
    2.7 =>77,
    2.6 =>76,
    2.5 =>75,
    2.4 =>74,
    2.3 =>73,
    2.2 =>72,
    2.1 =>71,
    2.0 =>70,
    1.9 =>69,
    1.8 =>68,
    1.7 =>67,
    1.6 =>66,
    1.5 =>65,
    1.4 =>64,
    1.3 =>63,
    1.2 =>62,
    1.1 =>61,
    1.0 =>60,
    0.9 =>59,
    0.8 =>58,
    0.7 =>57,
    0.6 =>56,
    0.5 =>56,
    0.4 =>56,
    0.3 =>56,
    0.2 =>56,
    0.1 =>56,
  }


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
 class FivePointConverter
   def self.convert(value)
    table = FIVE_POINT_CONVERTION_TABLE
    table[
      table.keys.min_by { |x| (value.to_f - x.to_f).abs}
    ]
   end
  end
  class FourPointConverter
   def self.convert(value)
    table = FOUR_POINT_CONVERTION_TABLE
    table[
      table.keys.min_by { |x| (value.to_f - x.to_f).abs}
    ]
   end
  end

  class LetterConverter
    def self.convert value
      LETTER_CONVERSION_TABLE[value]
    end
  end

  class HundredPointConverter
    def self.convert value
      value
    end
  end

  CONVERTERS = {0 => FourPointConverter, 1 => HundredPointConverter, 2 => LetterConverter, 3 => FivePointConverter}

  FORMATS = RANGES.keys

  def self.convert_to_hundred_point(value, format)
    converter = CONVERTERS[format]
    converter.convert(value)
  end

  def self.range_for format
    RANGES[format]
  end

  def self.validations_for format
    VALIDATIONS[format]
  end

  def self.description_for format
    "#{format.to_s.titleize}"
  end

  def hint_for format
    "ex: #{range_for(format)}"
  end

  def self.for_select
    FORMATS.each_with_index.map{|f,i| [description_for(f), i]}
  end

  def self.validations_by_index_for index
    validations_for FORMATS[index]
  end

  def self.range_by_format_index index
    range_for FORMATS[index]
  end

  def self.default_grade_range
    range_for :hundred_point
  end

  def self.default_validations
    validations_for :hundred_point
  end

  def self.validations_list
    FORMATS.map{|f| validations_for(f)}.to_json
  end


  private
end
