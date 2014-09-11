class Location < ActiveRecord::Base
  validates :location, :presence => true
end
