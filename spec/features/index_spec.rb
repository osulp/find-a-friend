require 'spec_helper'
require 'factory_girl_rails'

describe "homepage" do
  let(:location) {create(:location)}
  let(:post1) {create(:post, :with_location)}
  before do
    RubyCAS::Filter.fake("testonid")
    visit signin_path
    visit root_path
  end
  context "when logged in as an admin" do
    before do
      create(:admin, :onid => "testonid")
      visit root_path
    end
    it "should link to the admin page" do
      expect(page).to have_link("Admin")
    end
  end
  context "when not logged in as an admin" do
    it "should not have a link to the admin page" do
      expect(page).to_not have_link("Admin")
    end
  end
  context "when there are no posts" do
    it "should display a message" do
      expect(page).to have_content(I18n.t('post.my_posts.no_posts_message'))
      expect(page).to have_content(I18n.t('post.all_posts.no_posts_message'))
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
        context "when the year has passed" do
          before do
            post1.onid = "testonid"
            post1.meeting_time = "2011-01-01 00:00:00"
            post1.end_time = "2011-02-02 00:00:00"
            post1.save
            visit root_path
          end
          it "should not display the post" do
            expect(page).to_not have_content(post1.title)
          end
        end
        context "when the month has passed" do
          before do
            post1.onid = "testonid"
            post1.meeting_time = (Time.current - 1.months)
            post1.end_time = (Time.current - 1.months)
            post1.save
            visit root_path
          end
          it "should not display the post" do
            expect(page).to_not have_content(post1.title)
          end
        end
        context "when the day has passed" do
          before do
            post1.onid = "testonid"
            post1.meeting_time = (Time.current - 1.days)
            post1.end_time = (Time.current - 1.days)
            post1.save
            visit root_path
          end
          it "should not display the post" do
            expect(page).to_not have_content(post1.title)
          end
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
    context "when the post time has not passed and when logged in as the owner of the post" do
      before do
        visit root_path
        click_link "Post a New Group"
        fill_in "Title", :with => "test title"
        fill_in "Description", :with => "description"
        fill_in "Meeting time", :with => (DateTime.current.midnight+2.days).strftime(I18n.t('time.formats.default'))
        fill_in "End time", :with => (DateTime.current.midnight+2.days).strftime(I18n.t('time.formats.default'))
        fill_in "Location", :with => "test location string to input"
        click_button "Create Post"
        visit root_path
      end
      it "should display the post in 'my posts' but not in groups" do
        expect(page).to have_content("test title")
        within '#displayed-groups' do
          expect(page).to_not have_content("test title")
        end
      end
    end
    context "when the post time is nil and logged in as the owner of the post" do
      before do
        post1.meeting_time = nil
        post1.end_time = nil
        post1.onid = "testonid"
        post1.save
        visit root_path
      end
      it "should display the post only in 'my posts'" do
        expect(page).to have_content(post1.title)
        within "#displayed-groups" do
          expect(page).to_not have_content(post1.title)
        end
      end
    end
  end
end
