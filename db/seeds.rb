# frozen_string_literal: true

if Rails.env.development?
  address = Address.find_or_initialize_by(street:      '800 K St NW',
                                          city:        'Washington',
                                          state:       'DC',
                                          postal_code: '20001',
                                          county: 'District of Columbia',
                                          latitude:    '38.90204',
                                          longitude:   '-77.02284')
  # Will save Address with Office below

  office = Office.find_or_create_by(name: 'Post Office of Washington DC') do |office|
    address.skip_api_validation!
    office.address = address
  end

  email    = ENV['SEED_ADMIN_EMAIL'].presence || 'admin@example.com'
  password = ENV['SEED_ADMIN_PASSWORD'].presence || 'Password1'
  User.find_or_create_by(first_name: 'Postal',
                         last_name:  'Worker',
                         email:      email,
                         role:       'admin',
                         verified:   true,
                         invitation_accepted_at: Time.zone.now,
                         time_zone:  'Pacific Time (US & Canada)',
                         phone:      '(360) 610-7089') do |user|
    user.password              = password
    user.password_confirmation = password
    user.confirmed_at          = Time.zone.now
    user.offices << office
  end
end

%w(Amharic
   Arabic
   Austronesian
   Cantonese
   English
   Filipino
   French
   German
   Hawaiian
   Hindi
   Ilocano
   Japanese
   Khmer
   Korean
   Lao
   Mandarin
   Punjabi
   Romanian
   Russian
   Samoan
   Somali
   Spanish
   Tagalog
   Thai
   Ukrainian
   Vietnamese
   Other).each { |language| Language.find_or_create_by(name: language) }

['American Indian or Alaska Native',
 'Asian',
 'Black or African American',
 'Native Hawaiian or Other Pacific Islander',
 'White/Caucasian',
 'Other'].each { |race| Race.find_or_create_by(name: race) }

[{ min: 0, max: 2 },
 { min: 3, max: 5 },
 { min: 6, max: 9 },
 { min: 10, max: 12 },
 { min: 13, max: 17 }].each do |age_range|
  AgeRange.find_or_create_by(age_range)
end
