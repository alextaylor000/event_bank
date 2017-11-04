class AccountOpen < Event
  def apply
    account = Account.create!(
      account_id: account_id,
      email: data.fetch(:account_owner_email)
    )

    account.account_id
  end

  private

  def account_id
    data[:account_id] || id
  end
end
