class GradeRanger
  RANGES ={:four_point => 0..4,  :hundred_point => 0..100, :a_to_f =>%q(A B C D F), :a_plus_to_f =>%q(A+ A- A B+ B B- C+ C C- D+ D D- F)}
  FORMATS = RANGES.keys
  
  def self.range_for format
    RANGES[format]
  end

  def self.description_for format
    "#{format.to_s.titleize} (ex: #{range_for(format)})" 
  end

  def self.for_select
    FORMATS.each_with_index.map{|f,i| [description_for(f), i]}
  end
end
