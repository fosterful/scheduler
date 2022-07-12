# frozen_string_literal: true

FactoryBot.define do
  factory :need do
    association :office, strategy: :build
    user { association :user, offices: [@instance.office], role: 'social_worker', strategy: :build }
    # Todo, remove sequence(:id), but why does it cause it to fail if not present
    sequence(:id) { |number| number }
    start_at { Time.zone.now }
    expected_duration { 120 }
    preferred_language_id { 1 }
    transient do
      children_count { 1 }
    end

    after(:build) do |need, evaluator|
      need.age_ranges << build(:age_range)

      evaluator.children_count.times do
        need.children << build(:child, need_id: need.id)
      end
    end

    factory :need_with_shifts do
      after(:create) do |need|
        create_list(:shift, need.expected_duration / 60, need: need)
      end
    end

    factory :need_with_assigned_shifts do
      after(:create) do |need|
        create_list(:shift, need.expected_duration / 60, need: need, user: User.first)
      end
    end
  end
end
