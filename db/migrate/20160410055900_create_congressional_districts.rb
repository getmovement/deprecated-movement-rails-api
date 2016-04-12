class CreateCongressionalDistricts < ActiveRecord::Migration
  def change
    create_table :congressional_districts do |t|
      t.integer :united_states_subdivision_id
      t.integer :number
      t.string :state_postal_abbreviation
      t.string :state_name
      t.integer :congress_session
      t.geometry :polygon, srid: 4326

      t.timestamps null: false
    end

    add_index :congressional_districts, :polygon, using: :gist
  end
end
