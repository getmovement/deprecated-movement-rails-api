class CongressionalDistrict < ActiveRecord::Base
  belongs_to :united_states_subdivision

  def self.for_location(latitude, longitude)
    point = "SRID=4326;POINT(#{longitude} #{latitude})"
    where("ST_Intersects(#{self.table_name}.polygon, ?)", point)
  end
end
