# frozen_string_literal: true

FactoryBot.define do
  factory :need do
    association :office, strategy: :build
    user { association :user, offices: [@instance.office], role: 'social_worker', strategy: :build }
    start_at { Time.zone.now }
    expected_duration { 120 }
    number_of_children { 1 }
    preferred_language_id { 1 }

    after(:build) do |need|
      need.age_ranges << build(:age_range)
      need.children << build(:child) unless need.children.any?
    end

    factory :need_with_shifts do

      after(:create) do |need|
        create_list(:shift, need.expected_duration / 60, need: need)
      end
    end
  end
end
