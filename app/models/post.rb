class Post < ActiveRecord::Base
  validates :title, :onid, :location, presence: true
  validate :order?
  
  def self.today
    where("meeting_time >= ? AND meeting_time < ?", Time.current.midnight, Time.current.tomorrow.midnight)
  end

  def self.future
    where("meeting_time >= ? OR meeting_time IS NULL", Time.current.midnight)
  end

  def time_range
    (meeting_time..end_time)
  end

  private
  def order?
    return if self.meeting_time.nil? || self.end_time.nil?
    errors.add(:end_time, 'must be after start time') if self.meeting_time >= self.end_time
  end
end
