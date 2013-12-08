class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.string :subject
      t.string :level
      t.integer :questions

      t.timestamps
    end
  end
end
