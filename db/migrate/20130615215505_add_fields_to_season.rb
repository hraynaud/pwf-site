class AddFieldsToSeason < ActiveRecord::Migration
  def change
   add_column :seasons, :message, :string
  end
end
