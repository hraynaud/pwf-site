class AddAvatarToParents < ActiveRecord::Migration
  def change
    add_column :parents, :avatar, :string
  end
end
