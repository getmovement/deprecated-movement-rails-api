class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :street_1, null: false
      t.string :street_2
      t.string :city
      t.string :state_abbreviation, null: false
      t.string :zip_code

      t.timestamps null: false
    end
  end
end
