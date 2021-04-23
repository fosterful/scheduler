# frozen_string_literal: true

FactoryBot.define do
  factory :office do
    name { [Faker::Address.city, 'Office'].join(' ') }
    region { 1 }
    association :address, factory: %i(address fake), strategy: :build

    factory :wa_office do
      name { 'Vancouver Office' }
      association :address, factory: %i(address wa), strategy: :build
    end

    factory :or_office do
      name { "Port Kent Office" }
      association :address, factory: %i(address or), strategy: :build
    end

    before :create do |office|
      office.address.addressable = office if office.address.addressable.blank?
    end
  end
end
