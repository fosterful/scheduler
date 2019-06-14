# frozen_string_literal: true

FactoryBot.define do
  factory :race do
    name { Faker::Demographic.race }
  end
end
