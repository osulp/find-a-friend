require 'spec_helper'

describe "admin panel" do
  let(:admin) {create(:admin)}

  before do
    RubyCAS::Filter.fake(admin.onid)
    visit signin_path
    visit admin_index_path
  end
  context "when on the admin index path" do
    it "should display the admin panel" do
      within(".panel-default") do
        expect(page).to have_content("Administration Dashboard")
      end
    end
    it "should have links to the location and admin status pages" do
      within(".panel-default") do
        expect(page).to have_link("Update User Admin Status")
        expect(page).to have_link("Update Locations")
      end
    end
  end
  context "when updating the admin status of a person" do
    before do
      click_link "Update User Admin Status"
    end
    context "when on the index" do
      it "should display your onid" do
        expect(page).to have_content(admin.onid)
      end
    end
    context "when adding an admin" do
      before do
        click_link "Add an Admin"
      end
      it "should redirect to the new page" do
        expect(page).to have_field("Onid")
      end
      context "when creating the admin" do
        before do
          fill_in "Onid", :with => "testonid"
          click_button "Create Admin"
        end
        it "should create and display the new admin" do
          expect(page).to have_content("testonid")
        end
      end
    end
    context "when deleting an admin" do
      before do
        create(:admin, :onid => "balesh")
        visit admin_admins_path
        click_link "Delete"
      end
      it "should delete the admin" do
        expect(page).to_not have_content("balesh")
        expect(page).to have_content(admin.onid)
      end
    end
  end
  context "when updating location" do
    let(:location) {create(:location)}
    before do
      location
      click_link "Update Locations"
    end
    it "should display all the locations" do
      expect(page).to have_content(location.location)
    end
    it "should have links to add, edit, delete" do
      expect(page).to have_link("Add Location")
      expect(page).to have_link("Edit")
      expect(page).to have_link("Delete")
    end
    context "when adding a location" do
      before do
        click_link "Add Location"
        fill_in "Location", :with => "location text"
        click_button "Create Location"
      end
      it "should save and display the location" do
        expect(page).to have_content("location text")
      end
    end
    context "when editing a location" do
      before do
        location
        visit admin_locations_path
        click_link "Edit"
        fill_in "Location", :with => "new location text"
        click_button "Update Location"
      end
      it "should save, update, and display the new location" do
        expect(page).to have_content("new location text")
      end
    end
    context "when deleting a location" do
      before do
        location
        visit admin_locations_path
        click_link "Delete"
      end
      it "should delete the location" do
        expect(page).to have_content(I18n.t("admin.locations.success.deleting"))
        expect(page).to_not have_content(location.location)
      end
    end
  end
end
