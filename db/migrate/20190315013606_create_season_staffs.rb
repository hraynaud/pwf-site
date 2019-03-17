class CreateSeasonStaffs < ActiveRecord::Migration[5.2]
  def change
    create_table :season_staffs do |t|
      t.references :staff, foreign_key: true
      t.references :season, foreign_key: true

      t.timestamps
    end
  end
end
