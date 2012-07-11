class RenameStatusOnSeasons < ActiveRecord::Migration
  def up
    change_column :seasons, :status, :integer
    rename_column :seasons, :status, :status_cd
  end

  def down
    rename_column :seasons, :status_cd, :status
    change_column :seasons, :status, :string
  end
end
