class AddFeesToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :fencing_fee, :decimal, :precision => 8, :scale => 2
    add_column :seasons, :aep_fee, :decimal, :precision => 8, :scale => 2



  end
end
