class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.string :description
      t.datetime :beg_date
      t.datetime :end_date
      t.datetime :fall_registration_open
      t.datetime :spring_registration_open
      t.string :status

      t.timestamps
    end
  end
end
