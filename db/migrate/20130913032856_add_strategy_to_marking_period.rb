class AddStrategyToMarkingPeriod < ActiveRecord::Migration
  def change
    add_column :marking_periods, :strategy, :string
  end
end
