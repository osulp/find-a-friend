class Post < ActiveRecord::Base
  validates :title, :onid, :description, :location, presence: true
end
