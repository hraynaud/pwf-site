class AddWaitlistRegistrationDateToSeason < ActiveRecord::Migration[5.2]
  def change
    add_column :seasons, :waitlist_registration_date, :date
  end
end
