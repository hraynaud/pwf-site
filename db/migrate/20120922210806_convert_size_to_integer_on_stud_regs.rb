class ConvertSizeToIntegerOnStudRegs < ActiveRecord::Migration
  def up
    change_column :student_registrations, :size_cd, :integer
  end

  def down
    change_column :student_registrations, :size_cd, :string
  end
end
