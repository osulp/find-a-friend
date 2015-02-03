require 'spec_helper'

describe PostFacade do
  subject {PostFacade.new(user)}
  let(:user) { "testuser" }
  describe "#today_posts" do
    let(:result) { subject.today_posts }
    it "should return a PostCollectionDecorator" do
      expect(result).to be_kind_of PostCollectionDecorator
    end
  end

  describe "#user_future_posts" do
    let(:result) { subject.user_future_posts }
    it "should return a PostCollectionDecorator" do
      expect(result).to be_kind_of PostCollectionDecorator
    end
  end

  describe "#part_of_posts" do
    let(:result) { subject.part_of_posts }
    it "should return a PostCollectionDecorator" do
      expect(result).to be_kind_of PostCollectionDecorator
    end
  end
end
