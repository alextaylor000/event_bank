require 'rails_helper'

describe ApiController do
  describe '#command' do
    it 'works' do
      json = { command: 'hello_world', data: { a: 1, b: 2 } }
      post :command, params: json

      expect(response.status).to eq 200
    end
  end
end
