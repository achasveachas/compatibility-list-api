require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do

    before(:each) do
      @user = create(:user)
      @app = @user.applications.create(software: "CardKnox")
      @comment = @app.comments.create(body: "Comment Body")
    end

    it 'belongs to a user' do
      expect(@app.user.id).to eq(@user.id)
    end

    it 'has many comments' do
      expect(@app.comments.last.id).to eq(@comment.id)
    end 
  end
end
