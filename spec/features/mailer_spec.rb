require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

describe 'Mailer' do
  let(:post_with_recipient) {create(:post, :with_recipient)}
  let(:location) {create(:location)}
  before do
    RubyCAS::Filter.fake("testonid")
    visit signin_path
    visit root_path
  end
  context "When creating a new post" do
    before do
      visit new_post_path
    end

    context "and the post has email recipients without onid checked" do
      before do
        visit new_post_path
        fill_in "Title", :with => "Test Title"
        fill_in "Description", :with => "Test Description"
        fill_in "Location", :with => "Location String"
        fill_in "Meeting time", :with => Time.now
        fill_in "End time", :with => Time.now
        fill_in "Recipients", :with => "Email@test.com"
        uncheck I18n.t("post.reply_to_checkbox")
        click_button "Create Post"
      end
      it "should send the email" do
        expect(ActionMailer::Base.deliveries.length).to eq 1
        expect(ActionMailer::Base.deliveries.first.subject).to have_content("Test Title")
        expect(ActionMailer::Base.deliveries.first.body.raw_source).to_not have_content("testonid")
      end
      context "then when editing the post" do
        before do
          within("#displayed-groups") do
            click_link "Test Title"
          end
          click_link "Edit"
        end

        context "and the post has email recipients" do
          context "after changing info in the post" do
            before do
              fill_in "Title", :with => "New Title"
              uncheck I18n.t("post.reply_to_checkbox")
              click_button "Update Post"
            end
            it "should send a new email with the new information" do
              expect(ActionMailer::Base.deliveries.length).to eq 2
              expect(ActionMailer::Base.deliveries.last.subject).to have_content("New Title")
              expect(ActionMailer::Base.deliveries.last.subject).to_not have_content("Test Title")
              expect(ActionMailer::Base.deliveries.last.body.raw_source).to_not have_content("testonid")
              expect(ActionMailer::Base.deliveries.last.body.raw_source).to have_content("updated.")
            end
          end
        end
      end
    end
    context "and the post has email recipients with onid checked" do
      before do
        visit new_post_path
        fill_in "Title", :with => "Test Title"
        fill_in "Description", :with => "Test Description"
        fill_in "Location", :with => "Location String"
        fill_in "Meeting time", :with => Time.now
        fill_in "End time", :with => Time.now
        fill_in "Recipients", :with => "Email@test.com"
        click_button "Create Post"
      end
      it "should send the email" do
        expect(ActionMailer::Base.deliveries.length).to eq 1
        expect(ActionMailer::Base.deliveries.first.subject).to have_content("Test Title")
        expect(ActionMailer::Base.deliveries.first.reply_to).to eq ["testonid@onid.oregonstate.edu"]
        expect(ActionMailer::Base.deliveries.first.body.raw_source).to have_content("testonid")
      end
      context "then when editing the post" do
        before do
          within("#displayed-groups") do
            click_link "Test Title"
          end
          click_link "Edit"
        end

        context "and the post has email recipients" do
          context "after changing info in the post" do
            before do
              fill_in "Title", :with => "New Title"
              click_button "Update Post"
            end
            it "should send a new email with the new information" do
              expect(ActionMailer::Base.deliveries.length).to eq 2
              expect(ActionMailer::Base.deliveries.last.subject).to have_content("New Title")
              expect(ActionMailer::Base.deliveries.first.reply_to).to eq ["testonid@onid.oregonstate.edu"]
              expect(ActionMailer::Base.deliveries.first.body.raw_source).to have_content("testonid")
            end
          end
        end
      end
    end
  end
end
