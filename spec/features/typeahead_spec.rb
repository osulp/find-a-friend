require 'spec_helper'

describe "locations" do
  let(:admin) {create(:admin)}
  let(:location) {create(:location)}
  context "when logged in as an admin" do
    before do
      RubyCAS::Filter.fake(admin.onid)
      visit signin_path
      visit root_path
    end
  end
  context "when logged in as a non-admin" do
    before do
      RubyCAS::Filter.fake("testonid")
      visit signin_path
      visit root_path
    end
  end
  context "when not logged in" do
    before do
      visit root_path
    end
  end
end
