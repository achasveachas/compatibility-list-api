require 'rails_helper'

RSpec.describe Comment, type: :model do

  before(:each) do
    @user = User.create(username: Faker::Internet.user_name, password: Faker::Internet.password)
    @app = Application.new(software: "CardKnox")
    @comment = @app.comments.build(body: "Comment Body", user: @user)
    @invalid_comment = @app.comments.build(user: @user)
  end
  describe 'relationships' do



    it 'belongs to a user' do
      expect(@comment.user).to be_a(User)
    end

    it 'belongs to an application' do
      expect(@comment.application).to be_a(Application)
    end 
  end

  describe 'validations' do

    it 'validates presence of body' do
      expect(@invalid_comment).not_to be_valid
      expect(@invalid_comment.errors.full_messages).to include("Body can't be blank")
    end

  end
end
