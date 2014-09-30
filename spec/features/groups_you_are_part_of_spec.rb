require 'spec_helper'

describe "groups you are a part of" do
  let(:post1) {create(:post, :recipients => "testonid@onid.oregonstate.edu")}
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
    end
  end
end
