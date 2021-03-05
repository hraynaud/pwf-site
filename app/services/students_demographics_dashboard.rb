class StudentsDemographicsDashboard
  def initialize grp, season_id
    scope = grp == "aep" ? Demographic.for_season_students_in_aep(season_id) : Demographic.for_season_all_students(season_id)
    @stat = StatCalculator.new(scope)
  end

  def pct_of_students_per_incomge_range
    @stat.percentage_breakdown :income_range_cd, Demographic.income_ranges.keys
  end

  def pct_of_students_per_housing_status
    @stat.percentage_breakdown :home_ownership_cd, Demographic.home_ownerships.keys
  end

  def pct_of_students_per_max_education_level
    @stat.percentage_breakdown :education_level_cd,  Demographic.education_levels.keys
  end

  def count_of_students_per_incomge_range
    @stat.count_breakdown :income_range_cd, Demographic.income_ranges.keys 
  end

  def count_of_students_per_housing_status
    @stat.count_breakdown :home_ownership_cd, Demographic.home_ownerships.keys
  end

  def count_of_students_per_max_education_level
    @stat.count_breakdown :education_level_cd,  Demographic.education_levels.keys
  end

  def pct_of_students_per_gender
    @stat.percentage_breakdown :gender, ['M', 'F'] 
  end

  def count_of_students_per_gender
    @stat.count_breakdown :gender, ['M', 'F'] 
  end

  def count_of_students_per_ethnicity
    @stat.count_breakdown :ethnicity,   [ 
    "African American", "Latino", "Caucasian", "Asian",
    "South Asian" ,"Middle Eastern", "Native American", 
    "Pacififc Islander", "Other"
  ]
  end

  def pct_of_students_per_ethnicity
    @stat.percentage_breakdown :ethnicity,  [ 
    "African American", "Latino", "Caucasian", "Asian",
    "South Asian" ,"Middle Eastern", "Native American", 
    "Pacififc Islander", "Other"
  ]

  end


end
