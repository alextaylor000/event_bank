class AccountWithdraw < Event
  def process!
    if account_has_sufficient_funds?
      account.balance_in_cents -= withdrawal_amount_in_cents
      account.save!

      { account_id: account.account_id, balance_in_cents: account.balance_in_cents }
    else
      { error: 'Not enough funds'}
    end
  end

  private

  def account
    @account ||= Account.find_by_account_id!(account_id)
  end

  def account_id
    Integer(data[:account_id] || id)
  end

  def account_has_sufficient_funds?
    account.balance_in_cents >= withdrawal_amount_in_cents
  end

  def withdrawal_amount_in_cents
    Integer(data.fetch(:amount_in_cents))
  end
end
