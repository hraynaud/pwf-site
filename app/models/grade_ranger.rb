class GradeRanger
  RANGES ={:four_point => 1..4,  
    :hundred_point => 0..100, 
    # :a_to_f =>%w(A B C D F), 
    :a_plus_to_f =>%w(A+ A- A B+ B B- C+ C C- D+ D D- F)}
  VALIDATIONS ={
    four_point: [
      {type:'number', range:[1,4]}, 
      {message: "Must between 1.0 and 4.0"}
    ].to_json,

    hundred_point: [
      {type:'number', range:[1,100]}
    ].to_json,

    #a_to_f: [
      #{inlist:%w(A B C D F).join(",")}, 
      #{message: "Invalid grade, only 'A, B, C, D, or F'"}
    #].to_json ,

    a_plus_to_f: [
      {inlist: %w(A+ A- A B+ B B- C+ C C- D+ D D- F).join(",")},
      {message: "Invalid grade, only  'A+, A-, A, B+, B,  B-, C+, C, C-, D+, D, D- or F'"}
    ].to_json

  }
  FORMATS = RANGES.keys

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
