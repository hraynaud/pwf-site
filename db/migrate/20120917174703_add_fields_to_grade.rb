class AddFieldsToGrade < ActiveRecord::Migration
  def change
    add_column :grades, :report_card_id, :integer

    add_column :grades, :value, :string

  end
end
