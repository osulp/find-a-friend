require 'spec_helper'

describe PostsController do
  describe 'GET query' do
    context "with a location, start, and end" do
      let(:location) {"Test Location"}
      let(:start) {Time.current}
      let(:end_time) {Time.current+3.hours}
      let(:post) {}
      before do
        post
        get :query, :format => :json, :location => location, :start => start, :end => end_time
      end
      context "and there are matching posts" do
        let(:post) {create(:post, :meeting_time => Time.current-1.hour, :end_time => Time.current+4.hours, :location => location)}
        it "should return it" do
          expect(JSON.parse(response.body).length).to eq 1
        end
      end
    end
  end
end
