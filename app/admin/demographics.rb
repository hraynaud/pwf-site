ActiveAdmin.register Demographic do
  config.filters = false
  menu :parent => "Parents"
  includes :parent
  actions  :index, :show

  scope :confirmed, default: true

  index do
    column :parent, :sortable => "parents.last_name" do |dem|
      link_to dem.parent.name, admin_parent_path(dem.parent)
    end
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
    column "Actions" do |d|
      link_to "View", admin_demographic_path(d)
    end
  end

  csv do
    column("Parent Id") { |d|d.parent.id }
    column("Income Range") { |d| d.income_range }
    column("Education Level") { |d| d.education_level }
    column("Home Ownership") { |d| d.home_ownership }
    column("No. Minors"){ |d| d.num_minors }
    column("No. Adults"){ |d| d.num_adults }
  end

  show :title =>  proc{"Household Data for #{@demographic.parent.name} for #{@demographic.season.description}" } do
    attributes_table do

      row :num_minors
      row :num_adults
      row "Income Range" do
        demographic.income_range
      end

      row "Education Level" do
        demographic.education_level
      end

      row "Home Ownership"  do
        demographic.home_ownership
      end
    end
  end


  form do |f|
    f.inputs "#{demographic.parent.name} - #{demographic.season.description}" do
      f.input :num_minors
      f.input :num_adults
      f.input :income_range_cd, :as => :select, :collection => Demographic.income_ranges
      f.input :education_level_cd, :as => :select, :collection => Demographic.education_levels
      f.input :home_ownership_cd, :as => :select, :collection => Demographic.home_ownerships
    end
  end
end
