class Post < ActiveRecord::Base
  validates :title, :onid, :location, presence: true
  validate :order?
  
  def self.today
    where("meeting_time >= ? AND meeting_time < ?", Time.current.midnight, Time.current.tomorrow.midnight)
  end

  def self.future
    where("meeting_time >= ? OR meeting_time IS NULL", Time.current.midnight)
  end

  private
  def order?
    errors.add(:end_time, 'must be after start time') if self.meeting_time.nil? || self.end_time.nil? || self.meeting_time >= self.end_time
  end
end
