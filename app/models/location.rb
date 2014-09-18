class Location < ActiveRecord::Base
  validates :location, :presence => true

  mount_uploader :photo, PhotoUploader
end
