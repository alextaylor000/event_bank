class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.integer :account_id
      t.integer :balance_in_cents, null: false, default: 0

      t.timestamps
    end
  end
end
