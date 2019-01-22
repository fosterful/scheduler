# frozen_string_literal: true

FactoryBot.define do
  factory :shift do
    association :need, strategy: :build
    association :user, strategy: :build
    start_at { Time.zone.now }
    duration { 60 }
  end
end
