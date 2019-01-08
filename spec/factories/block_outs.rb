FactoryBot.define do
  factory :block_out do
    association :user, strategy: :build
    start_at { "2019-01-08 16:33:26" }
    end_at { "2019-01-08 16:33:26" }
    rrule { nil }
    reason { "On vacation" }
  end
end
