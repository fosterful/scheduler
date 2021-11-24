# frozen_string_literal: true

FactoryBot.define do
  factory :shift_survey do
    association :shift, strategy: :build
    notes { 'Here are some shift notes' }
  end
end
