class CreateCampaignVolunteers < ActiveRecord::Migration
  def change
    create_table :campaign_volunteers do |t|
      t.references :volunteer, references: :users, index: true, null: false
      t.references :campaign, index: true, null: false, foreign_key: true

      t.timestamps null: false
    end

    # we're using a columned not named 'user_id', so we need to add the foreign
    # key manually, instead of just using 'foreign_key: true'
    add_foreign_key :campaign_volunteers, :users, column: :volunteer_id
  end
end
