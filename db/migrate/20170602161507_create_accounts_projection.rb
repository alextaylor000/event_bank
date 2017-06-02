class CreateAccountsProjection < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts_projection do |t|
      t.integer :account_id
      t.integer :balance_in_cents
    end
  end
end
