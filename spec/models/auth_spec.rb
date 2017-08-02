require 'rails_helper'

RSpec.describe Auth, type: :model do
  describe 'JWT authentication' do
    it 'returns a token with the correct format' do
      token = Auth.create_token(1)
      binding.pry
      expect(token.split(".").length).to eq(3)
    end
  end
end
