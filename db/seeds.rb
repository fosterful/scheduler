if Rails.env.development?
  address = Address.where(
    street: "800 K St NW",
    city: "Washington",
    state: "DC",
    postal_code: "20001",
    latitude: "38.90204",
    longitude: "-77.02284"
  ).first_or_initialize
  # Will save Address with Office below

  age_range = AgeRange.where(
    min: 0,
    max: 2
  ).first_or_initialize
  age_range.save! unless age_range.persisted?

  office = Office.where(
    name: "Post Office of Washington DC"
  ).first_or_initialize
  unless office.persisted?
    address.skip_api_validation!
    office.address = address
    office.save!
  end

  user = User.where(
    first_name: 'Postal',
    last_name: 'Worker',
    email: 'postal@worker.mail',
    role: 'admin',
  ).first_or_initialize
  unless user.persisted?
    user.password = 'itismail'
    user.offices << office
    user.save!
  end
end
