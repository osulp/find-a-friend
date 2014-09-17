class Post < ActiveRecord::Base
  validates :title, :onid, :location, presence: true
end
