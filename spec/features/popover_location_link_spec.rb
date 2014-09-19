require 'spec_helper'

describe 'links to locations' do
  let(:location) {create(:location)}

  before do
    RubyCAS::Filter.fake("testonid")
    visit signin_path
    visit root_path
  end

  context "When creating a post with a location saved in the database" do
    before do
      location
      visit new_post_path
      fill_in "Title", :with => "Sample Title"
      fill_in "Location", :with => location.location
      click_button "Create Post"
    end

    it "should create a post with a link as the location" do
      expect(page).to have_link(location.location)
    end
  end

  context "When creating a post with a location saved in the database" do
    before do
      visit new_post_path
      fill_in "Title", :with => "Sample Title"
      fill_in "Location", :with => "Nothing"
      click_button "Create Post"
    end

    it "should create a post with a link as the location" do
      expect(page).to_not have_link("Nothing")
    end
  end


end