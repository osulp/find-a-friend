require 'spec_helper'

describe 'popular location' do
  let(:pop_location) {create(:post, :location => "popular location")}
  context "when there is already 20 posts at a location" do
    before do
      5.times {
        Post.create(:onid => "testonid", :title => "title", :description => "desc", :location => "popular location", :meeting_time => Time.current, :end_time => (Time.current + 2.hours))
      }
    end
    it "should have that many posts in the database" do
      expect(Post.all.count).to eq 5
    end
    context "when creating a new group with the same location" do
      before do
        RubyCAS::Filter.fake("onid1")
        visit signin_path
        visit new_post_path
        fill_in "Title", :with => "post title"
        fill_in "Description", :with => "post description"
        fill_in "Location", :with => "popular location"
        fill_in "Meeting time", :with => Time.now
        fill_in "End time", :with => Time.now + 2.hours
        click_button "Create Post"
      end
      it "should flash a warning that that location might be busy" do
        expect(page).to have_content(I18n.t('warnings.popular_location'))
      end
      context "when clicking to continue" do
        before do
          click_button "Save Post anyways"
        end
        it "should save and display the post" do
          expect(page).to have_content("post title")
          expect(page).to have_content("post description")
        end
      end
      context "when clicking cancel to change locations" do
        before do
          click_button "Cancel"
        end
        it "should redirect back to the post page" do
          expect(page).to have_content("New Post")
        end
      end
    end
  end
end
