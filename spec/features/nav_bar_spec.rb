require 'spec_helper'

describe 'navbar' do
  
  before do
    visit root_path
  end

  context "when browsing the home page" do    
    it "should have the nav bar on the top of the page" do
      expect(page).to have_selector('.navbar')
    end
    context "When using the nav bar" do      
      context "When clicking the Oregon State University button" do
        before do
          click_link "Oregon State University"
        end
        it "should route back to the home page" do
          expect(current_path).to eq root_path
        end
      end
      context "when not logged in" do
        before do
          visit root_path
        end
        it "should have a sign-in link" do
          within(".navbar") do
            expect(page).to have_link("Sign in")
          end
        end
      end
      context "when logged in" do
        before do
          RubyCAS::Filter.fake("testonid")
          visit signin_path
          visit root_path
        end
        it "should have a signout link" do
          within(".navbar") do
            expect(page).to have_link("Sign out")
          end
        end
        context "when adding a new post" do
          before do
            click_link "New post"
          end
          it "should show the new post page" do
            expect(page).to_not have_content(I18n.t("permission_error.error_string"))
          end
          context "when creating a new post" do
            before do
              fill_in "Title", :with => "test title"
              fill_in "Description", :with => "test description"
              fill_in "Location", :with => "Test Location"
              fill_in "Meeting time", :with => Time.now
              fill_in "End time", :with => Time.now
              click_button "Create Post"
            end
            it "should allow the user to create the post" do
              expect(page).to have_content(Post.first.title)
            end
          end
          context "when creating a new post with an empty field that is required" do
            before do
              fill_in "Title", :with => "test title"
              fill_in "Description", :with => "test description"
              click_button "Create Post"
            end
            it "should return an error and cant be blank error" do
              expect(page).to have_content("can't be blank")
            end
          end
        end
      end
      context "when logged in as an admin" do
        let(:admin) {create(:admin)}
        before do
          RubyCAS::Filter.fake(admin.onid)
          visit signin_path
          visit root_path
        end
        it "should link to the admin panel" do
          within(".navbar") do
            expect(page).to have_link("Admin")
          end
        end
      end
    end
  end
end
