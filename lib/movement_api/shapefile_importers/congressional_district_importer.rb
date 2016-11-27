module MovementApi
  module ShapefileImporters
    class CongressionalDistrictImporter
      def initialize(file)
        @file = file
      end

      def call
        RGeo::Shapefile::Reader.open(@file, srid: 4326) do |file|
          file.each do |record|
            fips_code = record.attributes["STATEFP"]
            subdivision = UnitedStatesSubdivision.find_by_fips_code(fips_code)
            if subdivision.present? && record.geometry.present? && record.attributes["CD114FP"] != "ZZ"
              district_number = record.attributes["CD114FP"].to_i
              congress_session = record.attributes["CDSESSN"].to_i

              attributes = {
                number: district_number,
                state_name: subdivision.name,
                congress_session: congress_session
              }

              unless CongressionalDistrict.exists?(attributes)
                CongressionalDistrict.create(
                  number: district_number,
                  state_name: subdivision.name,
                  congress_session: congress_session,
                  united_states_subdivision: subdivision,
                  state_postal_abbreviation: subdivision.postal_abbreviation,
                  polygon: record.geometry,
                )
              end
            end
          end
        end
      end
    end
  end
end
