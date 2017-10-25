FactoryGirl.define do
  factory :comment do
    association :user, username: Faker::Internet.user_name
    application 
    body "Comment Body"
  end
end
