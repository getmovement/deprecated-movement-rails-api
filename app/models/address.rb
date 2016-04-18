class Address < ActiveRecord::Base
  validates :street_1, presence: true

  validates(
    :latitude,
    presence: true,
    numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  )

  validates(
    :longitude,
    presence: true,
    numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  )

  validates :state_abbreviation, presence: true

  validates(
    :city,
    presence: { message: "can't be empty if zip code is empty" },
    unless: proc { |a| a.zip_code.present? }
  )

  validates(
    :zip_code,
    presence: { message: "can't be empty if city is empty" },
    unless: proc { |a| a.city.present? }
  )
end
