# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    street { Faker::Address.street_address }
    street2 { nil }
    city { Faker::Address.city }
    county { Faker::Address.street_name }
    state { Faker::Address.state_abbr }
    postal_code { Faker::Address.zip }

    trait :wa do
      street { "1901 Main St" }
      city { "Vancouver" }
      county { "Clark"}
      state { "WA" }
      postal_code { "98660" }
    end

    trait :or do
      street { Faker::Address.street_address }
      city { "Portland" }
      county { "Multnoma" }
      state { "OR" }
      postal_code { "97035" }
    end

    latitude { nil }
    longitude { nil }

    association :addressable, factory: :user, strategy: :build
  end
end
