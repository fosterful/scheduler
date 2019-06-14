# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Test' }
    last_name { 'User' }

    sequence :email do |n|
      "person#{n}@example.com"
    end

    password { 'foobar' }
    password_confirmation { 'foobar' }

    role { 'volunteer' }
    confirmed_at { Time.zone.now }
    invitation_accepted_at { Time.zone.now }

    birth_date { 35.years.ago }
    phone { '3606107089' }
    resident_since { 1.year.ago }
    discovered_omd_by { 'The interwebs' }
    medical_limitations { false }
    conviction { false }
    time_zone { 'Pacific Time (US & Canada)' }

    race_id { 1 }
    first_language_id { 1 }
    age_range_ids { [1] }

    after :build do |user|
      user.offices << build(:wa_office) unless user.offices.any?
    end

    factory :social_worker do
      role { 'social_worker' }
    end

    factory :coordinator do
      role { 'coordinator' }
    end

    factory :admin do
      role { 'admin' }
    end
  end
end
