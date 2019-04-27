class AddMinAtttendanceToSeason < ActiveRecord::Migration[5.2]
  def change
    add_column :seasons, :min_for_hoodie, :float
    add_column :seasons, :min_for_t_shirt, :float
  end
end
