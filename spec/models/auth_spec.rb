require 'rails_helper'

RSpec.describe Auth, type: :model do
  describe 'JWT authentication' do
    before(:each) do
      @token = Auth.create_token(1)
    end
    it 'returns a token with the correct format' do

      expect(@token.split(".").length).to eq(3)
    end    
    
    it 'decodes the token properly' do

      expect(Auth.decode_token(@token)[0]["user_id"]).to eq(1)
    end
  end
end
