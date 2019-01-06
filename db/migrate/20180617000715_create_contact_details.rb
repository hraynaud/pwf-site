class CreateContactDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_details do |t|
      t.references :user, foreign_key: true
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :primary_phone
      t.string :secondary_phone
      t.string :other_phone

      t.timestamps
    end
  end
end
