require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'relationships' do

    before(:each) do
      @user = User.create(username: Faker::Internet.user_name, password: Faker::Internet.password)
      @app = Application.new(software: "CardKnox")
      @comment = @app.comments.build(body: "Comment Body", user: @user)
      @app.save
    end

    it 'belongs to a user' do
      expect(@comment.user).to be_a(User)
    end

    it 'belongs to an application' do
      expect(@comment.application).to be_a(Application)
    end 
  end
end
