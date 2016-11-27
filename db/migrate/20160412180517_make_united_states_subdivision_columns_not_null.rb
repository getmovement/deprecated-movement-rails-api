class MakeUnitedStatesSubdivisionColumnsNotNull < ActiveRecord::Migration
  def change
    change_column_null :united_states_subdivisions, :fips_code, false
    change_column_null :united_states_subdivisions, :postal_abbreviation, false
    change_column_null :united_states_subdivisions, :name, false
  end
end
