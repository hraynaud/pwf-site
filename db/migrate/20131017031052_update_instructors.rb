class UpdateInstructors < ActiveRecord::Migration
	def change
       remove_column :instructors, :name  
       add_column :users, :is_instructor, :boolean
    end
end
