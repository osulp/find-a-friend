require 'spec_helper'

describe 'popular location' do
  let(:pop_location) {create(:post, :location => "popular location")}
  context "when there is already 5 posts at a location" do
    before do
      5.times {
        Post.create(:onid => "testonid", :title => "title", :description => "desc", :location => "popular location", :meeting_time => Time.current, :end_time => (Time.current + 2.hours))
      }
    end
    it "should have that many posts in the database" do
      expect(Post.all.count).to eq 5
    end
    context "when creating a new group with the same location", :js => true do
      before do
        RubyCAS::Filter.fake("onid1")
        visit signin_path
        visit new_post_path
        fill_in "Title", :with => "post title"
        fill_in "Description", :with => "post description"
        fill_in "Location", :with => "popular location"
        fill_in "Meeting time", :with => Time.now.strftime(I18n.t('time.formats.form'))
        fill_in "End time", :with => (Time.now + 2.hours).strftime(I18n.t('time.formats.form'))
        page.execute_script("window.popular_location_manager.location_busy = function(){$('body').addClass('locationbusy')}")
      end
      it "should be marked as busy" do
        click_button "Create Post"
        expect(page).to have_selector("body.locationbusy")
      end
    end
  end
end
