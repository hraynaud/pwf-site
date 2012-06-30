class RemoveDescriptionFromSeason < ActiveRecord::Migration
  def up
    remove_column :seasons, :description
  end

  def down
    add_column :seasons, :description, :string
  end
end
