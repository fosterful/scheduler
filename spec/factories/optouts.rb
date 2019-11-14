FactoryBot.define do
  factory :optout do
    association :user, strategy: :build
    association :need, strategy: :build
  end
end
