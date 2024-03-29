FactoryGirl.define do
  factory :user do |user|
    user.name 'Michael Hartl'
    user.email 'mhartl@example.com'
    user.password 'foobar'
    user.password_confirmation 'foobar'
  end
end

FactoryGirl.define do
  sequence :email do |n|
    "person-#{n}@example.com"
  end
end


FactoryGirl.define do
  factory :micropost do |micropost|
    micropost.content 'Foo Bar'
    micropost.association :user
  end
end