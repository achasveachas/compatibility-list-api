require 'rails_helper'

RSpec.describe Application, type: :model do

  before(:each) do
    @user = User.create(username: Faker::Internet.user_name, password: Faker::Internet.password)
    @app = @user.applications.new(software: "CardKnox", omaha: true)
    @comment = @app.comments.build(body: "Comment Body", user: @user)
    @incompatible_app = @user.applications.new(software: "BMS", omaha: false, nashville: false, north: false, buypass: false, elavon: false, tsys: false)
    @incompatible_app.comments.build(body: "Comment Body", user: @user)
    @app.save
    @incompatible_app.save

  end

  describe 'relationships' do

    it 'belongs to a user' do
      expect(@app.user.id).to eq(@user.id)
    end

    it 'has many comments' do
      expect(@app.comments.last.id).to eq(@comment.id)
    end 
  end

  describe 'attributes' do

    it "is compatible if it is compatible with any front-end" do
      expect(@app.compatible?).to be(true)
    end

    it "is incompatible if it is not compatible with any front-end" do
      expect(@incompatible_app.compatible?).to be(false)
    end
  end
end
