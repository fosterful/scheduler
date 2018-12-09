FactoryBot.define do
  factory :address do
    street { "1901 Main St" }
    street2 { nil }
    city { "Vancouver" }
    state { "WA" }
    postal_code { "98660" }

    latitude { nil }
    longitude { nil }

    association :addressable, factory: :user, strategy: :build
  end
end
