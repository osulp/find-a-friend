require 'spec_helper'

describe "admin about" do
  let(:about) {create(:about, :about_text => "test about text")}
  context "when on the index page" do
    before do
      visit root_path
    end
    context "when there is not an about text entered" do
      it "should not display the about heading" do
        expect(page).to_not have_content("About Find-a-Friend")
      end
    end
    context "when there is an about text entered" do
      before do
        about
        visit root_path
      end
      it "should display the about text" do
        expect(page).to have_content("About Find-a-Friend")
        expect(page).to have_content(about.about_text)
      end
    end
  end
end
