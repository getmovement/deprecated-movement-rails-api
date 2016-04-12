# == Schema Information
#
# Table name: congressional_districts
#
#  id                           :integer          not null, primary key
#  united_states_subdivision_id :integer          not null
#  number                       :integer          not null
#  state_postal_abbreviation    :string           not null
#  state_name                   :string           not null
#  congress_session             :integer          not null
#  polygon                      :geometry({:srid= not null, geometry, 4326
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

class CongressionalDistrict < ActiveRecord::Base
  belongs_to :united_states_subdivision

  validates :united_states_subdivision, presence: true
  validates :number, presence: true
  validates :state_postal_abbreviation, presence: true, length: { is: 2 }
  validates :state_name, presence: true
  validates :congress_session, presence: true

  def self.for_location(latitude, longitude)
    point = "SRID=4326;POINT(#{longitude} #{latitude})"
    where("ST_Intersects(#{self.table_name}.polygon, ?)", point)
  end
end
