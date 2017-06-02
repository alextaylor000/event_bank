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
    end # account_open

    describe 'account_deposit' do
      before { Account.create(id: 123) }

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
        and change { Account.find(123).balance_in_cents }.by(10_00)

        expect(JSON.parse(response.body)).to eq({ 'account_id' => 123, 'balance_in_cents' => 10_00 })
      end
    end
  end
end
