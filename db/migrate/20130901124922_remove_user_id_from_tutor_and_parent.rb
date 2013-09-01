class RemoveUserIdFromTutorAndParent < ActiveRecord::Migration
    remove_column :tutors, :user_id
    remove_column :parents, :user_id
end
