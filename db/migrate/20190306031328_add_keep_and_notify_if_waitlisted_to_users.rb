class AddKeepAndNotifyIfWaitlistedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :keep_and_notify_if_waitlisted, :boolean
  end
end
