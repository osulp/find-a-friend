class PostDecorator < Draper::Decorator
  delegate_all

  def FormatMeetingTime
    return object.meeting_time.strftime(I18n.t('time.formats.default')) unless object.meeting_time.nil?
    return "No Meeting Time Set"
  end

  def FormatEndingTime
    return object.end_time.strftime(I18n.t('time.formats.default')) unless object.end_time.nil?
    return "No Ending Time Set"
  end

  def today?
    return object.meeting_time.strftime(I18n.t('time.formats.date')) == Time.now.strftime(I18n.t('time.formats.date')) unless object.meeting_time.nil?
    return false
  end

  def past?
    if object.meeting_time.nil? && object.end_time.nil?
      return false
    elsif date_passed(object.meeting_time) && date_passed(object.end_time)
      return true
    else
      return false
    end
  end

  def recipient_onids
    recipients.split(",").map{|x| x.strip.split("@").first} | [onid]
  end

  def date_passed(object_date)
    if object_date.year.to_i < Time.now.year.to_i
      return true
    elsif object_date.month.to_i < Time.now.month.to_i
      return true
    elsif object_date.day.to_i < Time.now.day.to_i
      return true
    else
      return false
    end
  end

end

