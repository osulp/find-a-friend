require 'spec_helper'
require 'factory_girl_rails'

describe "homepage" do
  let(:post1) {create(:post)}
  before do
    RubyCAS::Filter.fake("testonid")
    visit signin_path
    visit root_path
  end
  context "when there are no posts" do
    it "should display a message" do
      expect(page).to have_content(I18n.t('post.no_posts_message'))
    end
  end
  context "when there are posts entered" do
    before do
      post1
      visit root_path
    end
    it "should display the posts" do
      expect(page).to have_link(post1.title)
      expect(page).to have_content(post1.description)
      expect(page).to have_content(post1.meeting_time.strftime(I18n.t('time.formats.default')))
    end
    context "when not logged in as the owner of the post" do
      it "should not have links to edit and delete posts" do
        expect(page).to_not have_content("Edit")
        expect(page).to_not have_content("Delete")
      end
    end
    context "when logged in as the creator of the post" do
      before do
        post1.onid = "testonid"
        post1.save
        visit root_path
      end
      context "when one of your posts has passed" do
        before do
          post1.onid = "testonid"
          post1.meeting_time = "2011-01-01 00:00:00"
          post1.save
          visit root_path
        end
        it "should not display the post" do
          expect(page).to_not have_content(post1.title)
        end
      end
      it "should display your posts at the top of the page" do
        expect(page).to have_content("Your Groups")
        expect(page).to have_content(post1.title, :count => 2)
      end
      it "should have links to edit and delete the post" do
        expect(page).to have_content("Edit")
        expect(page).to have_content("Delete")
      end
    end
  end
end
