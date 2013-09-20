class RenameUserTypeFields < ActiveRecord::Migration
  def change
    rename_column :users, :admin, :is_mgr
    rename_column :users, :parent, :is_parent
    rename_column :users, :tutor, :is_tutor
    User.all.each do |user|
      user.update_attribute(:is_parent, true)
      p = Parent.new
      p.update_attribute(:user_id, user.id)
      user.profileable = p
      user.save
      Demographic.where(:parent_id => user.id).map{|d|d.update_attribute(:parent_id,  p.id)}
      Student.where(:parent_id => user.id).map{|d|d.update_column(:parent_id,  p.id)}
      Payment.where(:parent_id => user.id).map{|d|d.update_column(:parent_id,  p.id)}
    end
  end
end
