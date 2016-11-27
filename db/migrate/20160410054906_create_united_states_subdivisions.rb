class CreateUnitedStatesSubdivisions < ActiveRecord::Migration
  def change
    create_table :united_states_subdivisions do |t|
      t.string :name
      t.string :postal_abbreviation
      t.string :fips_code

      t.timestamps null: false
    end

    add_index :united_states_subdivisions, :postal_abbreviation
    add_index :united_states_subdivisions, :fips_code
  end
end
