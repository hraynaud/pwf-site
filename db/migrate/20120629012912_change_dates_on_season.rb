class ChangeDatesOnSeason < ActiveRecord::Migration
  def up
    change_column :seasons, :beg_date, :date
    change_column :seasons, :end_date, :date
    change_column :seasons, :fall_registration_open, :date
    change_column :seasons, :spring_registration_open, :date
  end

  def down
    change_column :seasons, :beg_date, :datetime
    change_column :seasons, :end_date, :datetime
    change_column :seasons, :fall_registration_open, :datetime
    change_column :seasons, :spring_registration_open, :datetime
  end
end
