class AddUserRelationships < ActiveRecord::Migration
  def change
    create_table :user_relationships do |t|
      t.belongs_to :follower, index: true, null: false
      t.belongs_to :following, index: true, null: false

      t.timestamps null: false
    end

    add_index(:user_relationships, [:follower_id, :following_id], unique: true)
  end

end
