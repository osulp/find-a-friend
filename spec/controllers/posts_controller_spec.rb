require 'spec_helper'

describe PostsController do
  describe 'GET query' do
    context "with a location, start, and end" do
      let(:location) {"Test Location"}
      let(:start) {Time.current}
      let(:end_time) {Time.current+3.hours}
      let(:post1) {}
      before do
        post1
        get :query, :format => :json, :location => location, :start => start.iso8601, :end => end_time.iso8601
      end
      context "and there are matching posts" do
        let(:post1) {create(:post, :meeting_time => Time.current-1.hour, :end_time => Time.current+4.hours, :location => location)}
        it "should return it" do
          expect(JSON.parse(response.body).length).to eq 1
        end
      end
    end
  end

  describe "#update" do
    let(:post_1) { create(:post) }
    let(:username) {}
    let(:post_params) do
      {
        :title => "banana"
      }
    end
    before do
      controller.stub(:current_user).and_return(username) if username
      patch :update, :id => post_1.id, :post => post_params
    end
    context "when logged in" do
      let(:username) { "test1"} 
      context "and they don't own the post" do
        it "should redirect" do
          expect(response).to be_redirect
        end
        it "should set a flash message" do
          expect(flash[:error]).to eq t("post.errors.permissions")
        end
      end
      context "and they own the post" do
        let(:post_1) { create(:post, :onid => username) }
        it "should not set a flash message" do
          expect(flash[:error]).to be_nil
        end
      end
    end
  end

  describe "#destroy" do
    let(:post_1) { create(:post) }
    let(:username) {}
    before do
      controller.stub(:current_user).and_return(username) if username
      delete :destroy, :id => post_1.id
    end
    context "when logged in" do
      let(:username) { "test1"} 
      context "and they don't own the post" do
        it "should redirect" do
          expect(response).to be_redirect
        end
        it "should set a flash message" do
          expect(flash[:error]).to eq t("post.errors.permissions")
        end
      end
      context "and they own the post" do
        let(:post_1) { create(:post, :onid => username) }
        it "should not set a flash message" do
          expect(flash[:error]).to be_nil
        end
      end
    end
  end

  describe "#edit" do
    let(:post_1) { create(:post) }
    let(:username) {}
    before do
      controller.stub(:current_user).and_return(username) if username
      get :edit, :id => post_1.id
    end
    context "when not logged in" do
      it "should redirect" do
        expect(response).to be_redirect
      end
    end
    context "when logged in" do
      let(:username) { "test1" }
      context "and they don't own the post" do
        it "should redirect" do
          expect(response).to be_redirect
        end
        it "should set a flash message" do
          expect(flash[:error]).to eq t("post.errors.permissions")
        end
      end
    end
  end

end
