class AddFieldsToTutor < ActiveRecord::Migration
  def change
    add_column :tutors, :emergency_contact_name, :string
    add_column :tutors, :emergency_contact_primary_phone, :string
    add_column :tutors, :emergency_contact_secondary_phone, :string
    add_column :tutors, :emergency_contact_relationship, :string
    add_column :tutors, :returning, :boolean
    add_column :tutors, :season_id, :integer
  end

end
