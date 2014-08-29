class Post < ActiveRecord::Base
  validates :title, :onid, :description, :location, :meeting_time, :end_time, presence: true

  belongs_to :user

end
