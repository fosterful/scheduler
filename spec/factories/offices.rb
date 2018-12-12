FactoryBot.define do
  factory :office do
    name { "Vancouver Office" }
    after :build do |office|
      office.address = build(:address, addressable: office)
    end
  end
end
