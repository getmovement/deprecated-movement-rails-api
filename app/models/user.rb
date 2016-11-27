# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  encrypted_password :string(128)
#  confirmation_token :string(128)
#  remember_token     :string(128)
#  base_64_photo_data :string
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  first_name         :string
#  last_name          :string
#

class User < ActiveRecord::Base
  include Clearance::User

  ASSET_HOST_FOR_DEFAULT_PHOTO = "https://d3pgew4wbk2vb1.cloudfront.net/icons".freeze

  has_many :campaign_volunteerships, class_name: "CampaignVolunteer", foreign_key: :volunteer_id
  has_many :campaigns, through: :campaign_volunteerships

  has_many :active_relationships,
           class_name: "UserRelationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships,
           class_name: "UserRelationship", foreign_key: "following_id", dependent: :destroy

  has_many :following, through: :active_relationships, source: :following
  has_many :followers, through: :passive_relationships, source: :follower

  validates :email, presence: true

  has_attached_file :photo,
                    styles: { large: "500x500#", thumb: "100x100#" },
                    path: "users/:id/:style.:extension",
                    default_url: ASSET_HOST_FOR_DEFAULT_PHOTO + "/user_default_:style.png"

  validates_attachment_content_type :photo,
                                    content_type: %r{^image\/(png|gif|jpeg)}

  validates_attachment_size :photo, less_than: 10.megabytes

  def follow(other_user)
    active_relationships.create(following_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(following_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
