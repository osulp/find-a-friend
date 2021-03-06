require 'spec_helper'

describe "locations" do
  let(:location) {create(:location)}
  let(:admin) {create(:admin)}
  let(:post) {create(:post, :with_location)}
  let(:post1) {create(:post)}

  before do
    RubyCAS::Filter.fake(admin.onid)
    visit signin_path
    visit root_path
  end
  context "when there is a post with location" do
    before do
      post
      visit root_path
    end
    it "should display the post and the location string" do
      expect(page).to have_content(post.location)
    end
  end
  context "when there is a post and the location is added" do
    before do
      post1.location = location.location
      post1.save
      visit root_path
    end
    it "should display the post and location string" do
      expect(page).to have_content(location.location)
    end
  end
  context "when creating the post from the ui" do
    before do
      click_link "Post a New Group"
      fill_in "Title", :with => "title text"
      fill_in "Description", :with => "description text"
      fill_in "Location", :with => "location text"
      click_button "Create Post"
    end
    it "should display all the info twice" do
      expect(page).to have_content("title text", :count => 2)
      expect(page).to have_content("description text", :count => 2)
      expect(page).to have_content("location text", :count => 2)
    end
  end
  context "when creating a post from the ui with a location input" do
    before do
      location
      visit root_path
      click_link "Post a New Group"
      fill_in "Title", :with => "title text"
      fill_in "Description", :with => "description text"
      fill_in "Location", :with => location.location
      click_button "Create Post"
    end
    it "should display the post and info" do
      expect(page).to have_content("title text", :count => 2)
      expect(page).to have_content("description text", :count => 2)
      expect(page).to have_content(location.location, :count => 2)
    end
  end
  context "When creating a location with a photo" do
    before do
      visit new_admin_location_path
      fill_in "* Location", :with => "Stuff"
      fill_in "Description", :with => "Sample Description"
      attach_file("location_photo", "spec/fixtures/cats.jpg")
      click_button "Create Location"
    end
    it "should save and display it" do
      expect(page).to have_css('img')
      expect(page).to have_content("Sample Description")
    end
    context "on the home page" do
      before do
        visit root_path
      end
      it "is should have the info" do
        expect(page).to have_content("Sample Description")
      end
    end
  end
end
