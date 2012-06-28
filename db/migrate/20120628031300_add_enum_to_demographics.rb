class AddEnumToDemographics < ActiveRecord::Migration
  def change
    rename_column :demographics, :income_range, :income_range_cd
    rename_column :demographics, :education_level, :education_level_cd
    rename_column :demographics, :home_ownership, :home_ownership_cd
  end
end
