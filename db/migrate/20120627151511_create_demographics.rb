class CreateDemographics < ActiveRecord::Migration
  def change
    create_table :demographics do |t|
      t.integer :parent_id
      t.integer :num_adults
      t.integer :num_minors
      t.integer :income_range
      t.integer :education_level
      t.integer :home_ownership
      t.integer :season_id

      t.timestamps
    end
  end
end
