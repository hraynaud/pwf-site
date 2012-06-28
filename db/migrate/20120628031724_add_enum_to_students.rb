class AddEnumToStudents < ActiveRecord::Migration
  def change
    rename_column :students, :gender, :gender_cd
  end
end
