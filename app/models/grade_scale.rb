module GradeScale
  TYPES = ["FourPointNumeric", "HundredPointNumeric",  "AplustoFalpha"]

  def self.avg vals
    vals.sum/vals.count
  end

  class NonHundredPoint
    def self.hundred_point_equivalent grade
      GradeScale.avg(mapping[grade].to_f)
    end
  end

  class FourPointNumeric < NonHundredPoint
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

      def mapping
        {
          4.33=>97..100,
          4=>94..96,
          3.67=>90..93,
          3.33=>87..89,
          3=>83..86,
          2.67=>80..82,
          2.33=>76..79,
          2=>73..75,
          1.67=>69..72,
          1.33=>66..68,
          1=>62..65,
          0.67=>60..61,
          0=>0..59
        }
      end
    end
  end

  class HundredPointNumeric
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

      def mapping
        hash ={"A+"=> 97..100,
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
      end
    end
  end

end
