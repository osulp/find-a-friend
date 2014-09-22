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

  def recipient_onids
    recipients.split(",").map{|x| x.strip.split("@").first} | [onid]
  end

  def description_content(locations)
    unless locations.find_by(:location => post.location) == nil
      return locations.find_by(:location => post.location).description unless locations.find_by(:location => post.location).description == nil
      return ""
    else
      return ""
    end
  end

  def photo_content(locations)
    return h.image_tag((locations.find_by(:location => post.location).photo_url(:thumb))) unless locations.find_by(:location => post.location) == nil
    return ""
  end

  def location_string(locations)
    h.link_to_unless(!locations.map{|x| x.location}.include?(self.location), self.location, {}, 
    {
      :class => "myPopover",
      :href => "#",
      :rel => "popover",
      :tabindex => "0",
      :data => {:toggle => "popover", :trigger => "focus", :content => self.photo_content(locations).to_s.gsub('"',"'")+self.description_content(locations) },
      :title => self.location
    })
  end
end

