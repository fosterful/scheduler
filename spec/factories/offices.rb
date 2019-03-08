# frozen_string_literal: true

FactoryBot.define do
  factory :office do
    name { 'Vancouver Office' }
    region { 1 }
    after :build do |office|
      office.address = build(:address, addressable: office)
    end
  end
end
