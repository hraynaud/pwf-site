class StatCalculator

  def initialize dataset
    @dataset = dataset
  end

  def get_percentage_breakdown column, type
    map_group_names_to_values(get_percentage_values(column), type)
  end

  def get_count_breakdown column, type
    map_group_names_to_values(get_count_values(column), type)
  end

  def get_percentage_values column
    get_count_values(column).
      map{|v|
      (v*100.to_f/ get_count_values(column).sum).round(3)
    }
  end

  def get_count_values column
    group_and_count_by(column).values
  end

  def group_and_count_by column
    @dataset.group(column).count
  end

  def map_group_names_to_values data, type
    Hash[type.zip(data)]
  end


end
