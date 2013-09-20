class ConvertSizeToIntegerOnStudRegs < ActiveRecord::Migration
  def up
    #change_column :student_registrations, :size_cd, :integer
connection.execute(%q{
    alter table student_registrations
    alter column size_cd
    type integer using cast(size_cd as integer)
  })

  end

  def down
    change_column :student_registrations, :size_cd, :string
  end
end
