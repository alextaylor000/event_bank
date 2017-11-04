require 'rails_helper'

describe "Replaying events" do
  let(:account_123) { Account.find_by_account_id!(123) }
  let(:account_456) { Account.find_by_account_id!(456) }

  before do
    events = [
      AccountOpen.new(data: { account_id: 123, account_owner_email: 'a@a.com' }.to_json),
      AccountDeposit.new(data: { account_id: 123, amount_in_cents: 10_00 }.to_json),
      AccountDeposit.new(data: { account_id: 123, amount_in_cents: 5_25 }.to_json),

      AccountOpen.new(data: { account_id: 456, account_owner_email: 'b@b.com' }.to_json),
      AccountDeposit.new(data: { account_id: 456, amount_in_cents: 250_00 }.to_json)
    ]

    events.each(&:process!)
  end

  it 'projects the right state by replaying events in the correct order' do
    expect(account_123).to have_attributes(
      email: 'a@a.com',
      balance_in_cents: 15_25
    )

    expect(account_456).to have_attributes(
      email: 'b@b.com',
      balance_in_cents: 250_00
    )
  end

  it 'persists the events' do
    expect(Event.count).to eq 5
  end
end
