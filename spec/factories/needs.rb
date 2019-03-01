# frozen_string_literal: true

FactoryBot.define do
  factory :need do
    association :office, strategy: :build
    user { association :user, offices: [@instance.office], role: 'social_worker', strategy: :build }
    start_at { Time.zone.now }
    expected_duration { 120 }
    number_of_children { 1 }

    after(:build) do |need|
      need.age_ranges << build(:age_range)
    end

    factory :need_with_shifts do
      transient do
        shifts_count { 2 }
      end

      after(:create) do |need, evaluator|
        create_list(:shift, evaluator.shifts_count, need: need)
      end
    end
  end
end
