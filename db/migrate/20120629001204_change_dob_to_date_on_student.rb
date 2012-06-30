class ChangeDobToDateOnStudent < ActiveRecord::Migration
  def up
    change_column :students, :dob, :date
  end

  def down
    change_column :students, :dob, :datetime
  end
end
