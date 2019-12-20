# frozen_string_literal: true

FactoryBot.define do
  factory :office_user do
    association :user
    association :office
  end
end
