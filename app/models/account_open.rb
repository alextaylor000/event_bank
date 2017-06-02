class AccountOpen < Event
  def process!
    # TODO: should creating the projection be separate?
    account = Account.create!(
      email: data.fetch(:account_owner_email)
    )

    account.id
  end
end
