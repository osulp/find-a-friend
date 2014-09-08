class Post < ActiveRecord::Base
  validates :title, :onid, :description, :location, presence: true
  has_one :location
end
