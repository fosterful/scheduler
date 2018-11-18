FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    password { 'foobar' }
    password_confirmation { 'foobar' }
    role { 'volunteer' }
    confirmed_at { Time.now }
  end
end
