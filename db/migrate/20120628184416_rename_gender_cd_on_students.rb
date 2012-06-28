class RenameGenderCdOnStudents < ActiveRecord::Migration
  def up
    rename_column :students, :gender_cd, :gender
  end

  def down
    rename_column :students, :gender, :gender_cd
  end
end
