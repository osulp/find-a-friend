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
    elsif object.meeting_time.strftime(I18n.t('time.formats.date')) < Time.now.strftime(I18n.t('time.formats.date')) || object.end_time.strftime(I18n.t('time.formats.date')) < Time.now.strftime(I18n.t('time.formats.date'))
      return true
    else
      return false
    end
  end

end

