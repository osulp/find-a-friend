class Admin < ActiveRecord::Base
  validates :onid, :presence => true
end
