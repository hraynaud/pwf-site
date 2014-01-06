module GradeScale
  TYPES = ["FourPointNumeric", "HundredPointNumeric",  "AplustoFalpha"]

  module Common
    def avg grades
      vals = Array.wrap(grades)
      vals.sum/vals.count
    end
  end

  class HundredPointNumeric
    extend Common
    class << self
      def name
        "Hundred Point"
      end

      def description
        "Hundred point numeric scale from 0 to 100"
      end

      def range
        0..100
      end

      def validation_message
        "Must between 0 and 100"
      end

      def unit_type
        :number
      end

      def client_side_valiation
        {type:'number', range:[0,100]}.to_json
      end

      def hundred_point_equivalent grade
        grade.to_f
      end
    end
  end

  class NonHundredPoint
    extend Common
    def self.resolved_grade grade
      grade_range = mapping(grade)
      (grade_range.min + grade_range.max)/2
    end

    def self.hundred_point_equivalent grade
      avg(resolved_grade(grade).to_f)
    end
  end

  class FourPointNumeric < NonHundredPoint
    @@hash = {
      4.33..4.33=>97..100,
      4.0..4.32=>94..96,
      3.67..3.9=>90..93,
      3.33..3.66=>87..89,
      3.0..3.32=>83..86,
      2.67..2.99=>80..82,
      2.33..2.66=>76..79,
      2.0..2.32=>73..75,
      1.67..1.99=>69..72,
      1.33..1.66=>66..68,
      1.0..1.32=>62..65,
      0.67..0.99=>60..61,
      0.0..0.66=>0..59
    }

    class << self
      def description
        "Four Point"
      end

      def range 
        1..4
      end

      def validation_message
        "Must between 1.0 and 4.0"
      end

      def unit_type
        :number
      end

      def client_side_valiation
        [
          {type:'number', range:[1,4]}, 
          {message: validation_message}
        ].to_json
      end

      def mapping grade
        find_grade(grade.to_f)
      end

      def find_grade(number)
        @@hash.each do |four_pt_range, hundred_range|
          if four_pt_range === number
            return hundred_range
          end
        end
      end

    end
  end


  class AplustoFalpha < NonHundredPoint
    class << self
      def name
        "A+ to F"
      end

      def description
        "A+ through F Letter Grade"
      end

      def range
        %w(A+ A- A B+ B B- C+ C C- D+ D D- F)
      end

      def validation_message
        "Must between in #{range}"
      end

      def unit_type
        :alpha
      end

      def client_side_valiation
        {type:'number', range:[0,100]}.to_json
      end

      def mapping grade
      hash = {"A+"=> 97..100,
               "A"=> 94..96,
               "A-"=> 90..93,
               "B+"=> 87..89,
               "B"=> 83..86,
               "B-"=> 80..82,
               "C+"=> 76..79,
               "C"=> 73..75,
               "C-"=> 69..72,
               "D+"=> 66..68,
               "D"=> 62..65,
               "D-"=> 60..61,
               "F"=> 0..59
        }
      hash[grade]
      end
    end
  end

end
