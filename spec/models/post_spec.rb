require 'spec_helper'

describe Post do


  #Validations
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:onid)}
  it {should validate_presence_of(:location)}
  it "should validate the order of meeting and end times" do
    post = Post.create(:meeting_time => (Time.current + 5.hours))
    expect(post).to_not be_valid
  end
end
