ActiveAdmin.register Demographic do
  scope :current, :default => true do |demographics|
    demographics.where("season_id = ?", Season.current.id)
  end

  index do
    column :parent
    column "Income Range", :income_range_cd, :sortable => :income_range_cd do |d|
      d.income_range
    end

column "Education Level", :education_level_cd, :sortable => :education_level_cd do |d|
      d.education_level
    end

    column "Home Ownership", :home_ownership_cd, :sortable => :home_ownership_cd do|d|
      d.home_ownership
    end
    column :num_minors
    column :num_adults
    column :season
  end

end
