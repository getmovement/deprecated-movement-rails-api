class AddPhotoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :base_64_photo_data, :string
    add_attachment :users, :photo
  end
end
