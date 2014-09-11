require 'spec_helper'

describe "post show" do
  let(:post) {create(:post, :with_location)}

  context "when there is a post entered" do
    before do
      post
      visit root_path
    end
    context "when logged in as the creator of the post" do
      before do
        RubyCAS::Filter.fake("testonid")
        visit signin_path
        post.onid = "testonid"
        post.save
      end
      context "when visiting the show view" do
        before do
          visit post_path(post)
        end
        it "should allow you to view the page" do
          expect(page).to_not have_content(I18n.t('permission_error.error_string'))
          expect(page).to have_content(post.title)
        end
        it "should display all the information" do
          expect(page).to have_content(post.title)
          expect(page).to have_content(post.description)
          expect(page).to have_content(post.location)
          expect(page).to have_content(post.meeting_time.strftime(I18n.t('time.formats.default')))
          expect(page).to have_content(post.end_time.strftime(I18n.t('time.formats.default')))
          expect(page).to have_content(post.recipients)
        end
      end
    end
  end
end
