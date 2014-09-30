require 'spec_helper'

describe "groups you are a part of" do
  let(:post1) {create(:post, :recipients => "testonid@onid.oregonstate.edu", :allow_onid => true)}
  before do
    RubyCAS::Filter.fake("testonid")
    visit signin_path
    visit root_path
  end
  context "when logged in as the recipient of a post" do
    before do
      post1
      visit root_path
    end
    context "when looking at posts that you are a part of tab" do
      before do
        click_link "Groups you are part of"
      end
      it "should display that group" do
        expect(page).to have_content(post1.title)
      end
      context "when the onid is allowed to be displayed" do
        before do
          post1.allow_onid = true
          post1.save
          visit root_path
          click_link "Groups you are part of"
        end
        it "should display the onid" do
          expect(page).to have_content("Contact ONID")
          expect(page).to have_content(post1.onid)
        end
      end
      context "when the onid is not allowed to be displayed" do
        before do
          post1.allow_onid = false
          post1.save
          visit root_path
          click_link "Groups you are part of"
        end
        it "should not display the onid" do
          expect(page).to have_content("Contact ONID")
          expect(page).to_not have_content(post1.onid)
        end
      end
    end
  end
end
