class Device < ActiveRecord::Base
  belongs_to :user

  validates :platform, presence: true
  validates :token, presence: true
  validates :user, presence: true
end
