class UpdateCommentsFields < ActiveRecord::Migration
  def up
    change_column :session_reports, :comments, :text
    change_column :session_reports, :mgr_comment, :text
  end

  def down
  end
end
