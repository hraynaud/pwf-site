class ChangeGroupIdType < ActiveRecord::Migration
	remove_column :student_registrations, :group_id
	add_column :student_registrations, :group_id, :integer
end
