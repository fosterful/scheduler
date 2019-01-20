FactoryBot.define do
  factory :need do
    association :office, strategy: :build
    association :user, strategy: :build
    preferred_language_id { 1 }
    start_at { Time.zone.now }
    expected_duration { 120 }
    number_of_children { 1 }
  end
end
