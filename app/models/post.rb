class Post < ActiveRecord::Base
  validates :title, :onid, :location, presence: true
  
  def self.today
    where("meeting_time >= ? AND meeting_time < ?", Time.current.midnight, Time.current.tomorrow.midnight)
  end

  def self.future
    where("meeting_time >= ? OR meeting_time IS NULL", Time.current.midnight)
  end
end
