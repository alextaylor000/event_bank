require 'rails_helper'

describe ApiController do
  describe '#command' do
    describe 'account_open' do
      it 'works' do
        json = { command: 'account_open', data: { account_owner_email: 'alex@taylor.com' } }

        expect {
          post :command, params: json
        }.to change { Event.all.count }.by(1).
        and change { Account.all.count }.by(1)

        expect(response.body).to eq Account.last.id.to_s
      end

      it 'works with an account id' do
        json = { command: 'account_open', data: { account_id: 456, account_owner_email: 'alex@taylor.com' } }

        expect {
          post :command, params: json
        }.to change { Event.all.count }.by(1).
        and change { Account.all.count }.by(1)

        expect(response.body).to eq Account.last.account_id.to_s
        expect(Account.last.account_id).to eq 456
      end
    end # account_open

    describe 'account_deposit' do
      # NOTE: whoa, you can use events for setting up tests too! :mindblown:
      before do
        AccountOpen.create(data: { account_id: 123, account_owner_email: 'a@a.com' }.to_json)
          .process!
      end

      it 'works' do
        json = {
          command: 'account_deposit',
          data: {
            account_id: 123,
            amount_in_cents: 10_00 
          }
        }

        expect {
          post :command, params: json
        }.to change { Event.all.count }.by(1).
        and change { Account.find_by_account_id!(123).balance_in_cents }.by(10_00)

        expect(JSON.parse(response.body)).to eq({ 'account_id' => 123, 'balance_in_cents' => 10_00 })
      end
    end
  end
end
