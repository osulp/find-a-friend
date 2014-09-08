class Location < ActiveRecord::Base
  validates :location, :presence => true
  belongs_to :post
end
