FactoryBot.define do
  factory :block_out do
    association :user, strategy: :build
    start_at { 1.day.from_now }
    end_at { 1.day.from_now + 1.hour }
  end
end
