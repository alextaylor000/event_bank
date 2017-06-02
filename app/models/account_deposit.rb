class AccountDeposit < Event
  def process!
    account = Account.find_by_account_id!(account_id)
    account.balance_in_cents += deposit_amount
    account.save!

    {
      account_id: account.account_id,
      balance_in_cents: account.balance_in_cents
    }
  end

  private

  def account_id
    Integer(data.fetch(:account_id))
  end

  def deposit_amount
    Integer(data.fetch(:amount_in_cents))
  end
end
