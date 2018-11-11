FactoryBot.define do
  factory :user do
    email { 'foo@example.com' }
    password { 'foobar' }
    password_confirmation { 'foobar' }
  end
end
