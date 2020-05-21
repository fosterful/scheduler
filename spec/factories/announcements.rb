FactoryBot.define do
  factory :announcement do
    message { "MyText" }
    author { nil }
    user_ids { "" }
  end
end
