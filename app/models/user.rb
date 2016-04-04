class User < ActiveRecord::Base
  include Clearance::User

  validates :email, presence: true
end
