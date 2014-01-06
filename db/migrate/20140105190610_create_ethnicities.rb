class CreateEthnicities < ActiveRecord::Migration
  def change
    create_table :ethnicities do |t|
      t.string :title

      t.timestamps
    end
  end
end
