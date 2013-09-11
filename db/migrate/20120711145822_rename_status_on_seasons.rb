class RenameStatusOnSeasons < ActiveRecord::Migration
  def up

connection.execute(%q{
    alter table seasons
    alter column status
    type integer using cast(seasons as integer)
  })
    #change_column :seasons, :status, :integer
    rename_column :seasons, :status, :status_cd
  end

  def down
    rename_column :seasons, :status_cd, :status
    change_column :seasons, :status, :string
  end
end
