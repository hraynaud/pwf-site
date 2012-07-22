ActiveAdmin.register Demographics do
  index do
    column :parent
    column :income_range
    column :education_level
    column :home_ownership
    column :num_minors
    column :num_adults
    column :season
  end

end
