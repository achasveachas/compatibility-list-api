require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it 'belongs to a user' do
      user = create(:user)
      app = user.applications.create(software: "CardKnox")

      expect(app.user.id).to eq(user.id)
    end
  end
end
