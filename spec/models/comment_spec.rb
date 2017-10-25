require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'relationships' do

    before(:each) do
      @comment = create(:comment)
    end

    it 'belongs to a user' do
      expect(@comment.user).to be_a(User)
    end

    it 'belongs to an application' do
      expect(@comment.application).to be_a(Application)
    end 
  end
end
