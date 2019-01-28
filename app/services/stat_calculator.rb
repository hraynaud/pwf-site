class StatCalculator

  def initialize dataset
    @dataset = dataset
  end

  def percentage_breakdown column, groupings
    map_group_names_to_values(percentage_values(column), groupings)
  end

  def count_breakdown column, groupings
    map_group_names_to_values(count_values(column), groupings)
  end

  def percentage_values column
    values = count_values(column)
    sum = values.sum
    values.map{|v|(v*100.to_f/ sum).round(3)}
  end

  def count_values column
    group_and_count_by(column).values
  end

  def group_and_count_by column
    @dataset.group(column).count
  end

  def map_group_names_to_values data, groupings
    Hash[groupings.zip(data)]
  end


end
