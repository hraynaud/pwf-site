class AddSeasonToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :season_id, :integer

  end
end
