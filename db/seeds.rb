# frozen_string_literal: true

if Rails.env.development?
  address = Address.where(
    street: '800 K St NW',
    city: 'Washington',
    state: 'DC',
    postal_code: '20001',
    latitude: '38.90204',
    longitude: '-77.02284'
  ).first_or_initialize
  # Will save Address with Office below

  age_range = AgeRange.where(
    min: 0,
    max: 2
  ).first_or_initialize
  age_range.save! unless age_range.persisted?

  office = Office.where(
    name: 'Post Office of Washington DC'
  ).first_or_initialize
  unless office.persisted?
    address.skip_api_validation!
    office.address = address
    office.save!
  end

  user = User.where(
    first_name: 'Postal',
    last_name: 'Worker',
    email: ENV.fetch('SEED_ADMIN_EMAIL', 'admin@example.com'),
    role: 'admin'
  ).first_or_initialize
  unless user.persisted?
    user.password = ENV.fetch('SEED_ADMIN_PASSWORD', 'Password1')
    user.password_confirmation = user.password
    user.confirmed_at = Time.zone.now
    user.offices << office
    user.save!
  end
end

%w(Spanish Mandarin Cantonese Vietnamese Russian Tagalog Filipino Korean Amharic Somali
   Austronesian Ilocano Samoan Hawaiian German Ukrainian Romanian Japanese Hindi French Khmer
   Arabic Punjabi Thai Lao Other).each do |language|
  Language.find_or_create_by(name: language)
end

%w(White/Caucasian Black/African American Hispanic Asian Native Hawaiian/Pacific Islander
   Eastern European Indian American Indian/Alaska Native Other).each do |race|
  Race.find_or_create_by(name: race)
end

[{min: 0, max: 2}, {min: 3, max: 5}, {min: 6, max: 9}, {min: 10, max: 12}, {min: 13, max: 17}].each do |age_range|
  AgeRange.find_or_create_by(age_range)
end
