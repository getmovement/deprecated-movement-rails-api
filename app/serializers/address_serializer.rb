class AddressSerializer < ActiveModel::Serializer
  attributes :id, :street_1, :street_2, :city, :state_abbreviation, :zip_code,
             :latitude, :longitude
end
