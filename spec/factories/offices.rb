# frozen_string_literal: true

FactoryBot.define do
  factory :office do
    name { [Faker::Address.city, 'Office'].join(' ') }
    region { 1 }
    association :address, factory: [:address, :fake], strategy: :build

    factory :wa_office do
      name { 'Vancouver Office' }
      association :address, factory: [:address, :wa], strategy: :build
    end

    factory :or_office do
      association :address, factory: [:address, :or], strategy: :build
    end

    before :create do |office|
      office.address.addressable = office unless office.address.addressable.present?
    end
  end
end
