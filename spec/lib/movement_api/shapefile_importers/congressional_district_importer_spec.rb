require "rails_helper"
require "movement_api/shapefile_importers/congressional_district_importer"

module MovementApi
  module ShapefileImporters
    describe CongressionalDistrictImporter do
      let(:file) { "spec/support/fixtures/shapefiles/congressional_districts/file.shp" }

      subject { CongressionalDistrictImporter.new(file) }

      it "has the right number of districts in the shapefile" do
        RGeo::Shapefile::Reader.open('spec/support/fixtures/shapefiles/congressional_districts/file.shp', srid: 4326) do |file|
          expect(file.num_records).to eq 4
        end
      end

      describe "#call" do
        it "creates CongressionalDistrict models" do
          expect { subject.call }.to change{CongressionalDistrict.count}.from(0).to(3)
        end
      end
    end
  end
end
