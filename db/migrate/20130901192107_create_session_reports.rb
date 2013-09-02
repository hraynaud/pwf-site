class CreateSessionReports < ActiveRecord::Migration
  def change
    create_table :session_reports do |t|

      t.timestamps
    end
  end
end
