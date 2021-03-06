require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires a username and a password upon creation' do
      user1 = build(:user, username: nil, password: nil)
      user2 = build(:user, password: nil)
      user3 = build(:user, username: nil)

      expect(user1.valid?).to equal(false)
      expect(user1.errors.full_messages).to eq([
        "Password can't be blank",
        'Password is too short (minimum is 8 characters)',
        "Username can't be blank"
        ])

      expect(user2.valid?).to equal(false)
      expect(user2.errors.full_messages).to eq([
        "Password can't be blank",
        'Password is too short (minimum is 8 characters)'
        ])

      expect(user3.valid?).to equal(false)
      expect(user3.errors.full_messages).to eq([
        "Username can't be blank"
        ])
    end

    it 'requires that the username be unique' do
      create(:user)
      user = build(:user)

      expect(user.valid?).to equal(false)
      expect(user.errors.full_messages).to eq([
        "Username has already been taken"
        ])
    end

    it 'accepts an optional "name" attribute and capitalizes it' do
      user = create(:user, name: "yechiel")

      expect(user.valid?).to equal(true)
      expect(user).to have_attribute(:name)
      expect(user.name).to eq("Yechiel")
    end

    it 'requires that a password be at least 8 characters long' do
      user1 = build(:user, password: 'short')
      user2 = build(:user, password: 'notshort')

      expect(user1.valid?).to equal(false)
      expect(user1.errors.full_messages).to eq([
        "Password is too short (minimum is 8 characters)"
        ])
    end

    it 'has an optional admin? attribute that defaults to false' do
      user = create(:user)
      expect(user).not_to be_admin
      user.update_attribute(:admin, true)
      expect(user).to be_admin
    end

  end

  describe 'on save' do
    it 'hashes a password' do
      user = build(:user)
      user.save

      expect(user.password_digest).not_to eq(user.password)
    end
  end

  describe 'relationships' do

    before(:each) do
      @user = create(:user)
      @app = @user.applications.new(software: "CardKnox")
      @comment = @app.comments.build(body: "Comment Body", user_id: @user.id)
      @app.save
    end

    it 'has many applications' do
      expect(@user.applications.first).to be_a(Application)
    end

    it 'has many comments' do
      expect(@user.comments.first).to be_a(Comment)
    end

  end

end
