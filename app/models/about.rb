class About < ActiveRecord::Base
  validates :about_text, :presence => true
end
