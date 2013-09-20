class AddProgramToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :program_cd, :integer
  end
end
