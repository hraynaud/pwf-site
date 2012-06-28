class AddDeviseToParents < ActiveRecord::Migration
  def self.up
    change_table(:parents) do |t|
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
    end

    rename_column :parents, :password_digest, :encrypted_password

    add_index :parents, :email,                :unique => true
    add_index :parents, :reset_password_token, :unique => true

  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
