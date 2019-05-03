# frozen_string_literal: true

FactoryBot.define do
  factory :office do
    name { [Faker::Address.city, 'Office'].join(' ') }
    region { 1 }
    trait :wa do
      after :build do |office|
        office.address = build(:address, :wa, addressable: office) unless office.address.present?
      end
    end

    trait :or do
      after :build do |office|
        office.address = build(:address, :or, addressable: office)
      end
    end

    after :build do |office|
      office.address ||= build(:address, :fake, addressable: office)
    end

    after :create do |office|
      office.address.addressable = office unless office.address.addressable.present?
    end
  end
end
