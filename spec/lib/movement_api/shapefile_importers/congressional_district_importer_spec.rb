require "rails_helper"
require "movement_api/shapefile_importers/congressional_district_importer"

module MovementApi
  module ShapefileImporters
    describe CongressionalDistrictImporter do
      let(:file) { "spec/support/fixtures/shapefiles/congressional_districts/file.shp" }

      subject { CongressionalDistrictImporter.new(file) }

      describe "#call" do
        it "creates CongressionalDistrict models" do
          expect { subject.call }.to change{CongressionalDistrict.count}.from(0).to(3)
        end
      end
    end
  end
end
