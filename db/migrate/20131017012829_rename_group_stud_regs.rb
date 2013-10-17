class RenameGroupStudRegs < ActiveRecord::Migration
	rename_column :student_registrations, :group, :group_id
end
