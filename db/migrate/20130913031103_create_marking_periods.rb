class CreateMarkingPeriods < ActiveRecord::Migration
  def change
    create_table :marking_periods do |t|
      t.string :name
      t.string :notes

      t.timestamps
    end
  end
end
