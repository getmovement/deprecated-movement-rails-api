class User < ActiveRecord::Base
  include Clearance::User

  ASSET_HOST_FOR_DEFAULT_PHOTO = "https://d3pgew4wbk2vb1.cloudfront.net/icons".freeze

  validates :email, presence: true

  has_attached_file :photo,
                    styles: {
                      large: "500x500#",
                      thumb: "100x100#"
                    },
                    path: "users/:id/:style.:extension",
                    default_url: ASSET_HOST_FOR_DEFAULT_PHOTO + "/user_default_:style.png"

  validates_attachment_content_type :photo,
                                    content_type: %r{^image\/(png|gif|jpeg)}

  validates_attachment_size :photo, less_than: 10.megabytes
end
