class CreateCongressionalDistricts < ActiveRecord::Migration
  def change
    create_table :congressional_districts do |t|
      t.integer :united_states_subdivision_id, null: false
      t.integer :number, null: false
      t.string :state_postal_abbreviation, null: false
      t.string :state_name, null: false
      t.integer :congress_session, null: false
      t.geometry :polygon, srid: 4326, null: false

      t.timestamps null: false
    end

    add_index :congressional_districts, :polygon, using: :gist
  end
end
