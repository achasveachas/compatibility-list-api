require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do

    before(:each) do
      @user = User.create(username: Faker::Internet.user_name, password: Faker::Internet.password)
      @app = @user.applications.new(software: "CardKnox")
      @comment = @app.comments.build(body: "Comment Body", user: @user)
      @app.save

    end

    it 'belongs to a user' do
      expect(@app.user.id).to eq(@user.id)
    end

    it 'has many comments' do
      expect(@app.comments.last.id).to eq(@comment.id)
    end 
  end
end
