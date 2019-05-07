# frozen_string_literal: true

FactoryBot.define do
  factory :office do
    name { [Faker::Address.city, 'Office'].join(' ') }
    region { 1 }

    after :build do |office|
      office.address ||= build(:address, :fake, addressable: office) unless office.address
    end

    factory :wa_office do
      name { 'Vancouver Office' }
      after :build do |office|
        office.address = build(:address, :wa, addressable: office)
      end
    end

    factory :or_office do
      after :build do |office|
        office.address = build(:address, :or, addressable: office)
      end
    end


    after :create do |office|
      office.address.addressable = office unless office.address.addressable.present?
    end
  end
end
