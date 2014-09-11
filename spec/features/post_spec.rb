require 'spec_helper'

describe 'Posts' do
  let(:post) {create(:post, :with_location)}
  let(:location) {create(:location) }

  context "When logged in" do
  	before do
      RubyCAS::Filter.fake("testonid")
      visit signin_path
      visit root_path
    end

    context "when there is a post on today" do
      before do
        post
        visit root_path
      end

      it "should display the post" do
        expect(page).to have_content(post.title)
      end
    end

    context "when there is a post for a day in the past" do
      before do
        location
        visit new_post_path
        fill_in "Title", :with => "Test Title"
        fill_in "Description", :with => "Test Description"
        fill_in "Meeting time", :with => "1990-01-01 12:00:00"
        fill_in "End time", :with => "1999-01-01 12:00:00"
        fill_in "Location", :with => "Location String"
        click_button "Create Post"
      end
      it "should not display the post in groups" do
        within "#displayed-groups" do
          expect(page).to_not have_content("Test Title")
        end
      end
      it "should not display the post in my groups" do
        expect(page).to_not have_content("Test Title")
      end
    end
    context "when there is a post for a day in the future" do
      before do
        location
        visit new_post_path
        fill_in "Title", :with => "Test Title"
        fill_in "Description", :with => "Test Description"
        fill_in "Meeting time", :with => Time.now + 2.day.to_i
        fill_in "End time", :with => Time.now + 3.day.to_i
        fill_in "Location", :with => "Location String"
        click_button "Create Post"
      end
      it "should not display the post in groups" do
        within '#displayed-groups' do
          expect(page).to_not have_content("Test Title")
        end
      end
    end
    context "and trying to create a new post" do
  	  before do
        visit new_post_path
        @now = Time.now.strftime(I18n.t('time.formats.form'))
        @now12 = Time.now.strftime((Time.now + 12.hour.to_i).strftime(I18n.t('time.formats.form')))
      end
      
      it "should have default times in the respective forms" do
        within '.meeting_input' do
          expect(page).to have_selector("input[value='#{@now}']")
        end
        within '.end_input' do
          expect(page).to have_selector("input[value='#{@now12}']")
        end
      end

      context "after filling all the forms out" do
        before do
          visit root_path
          click_link "New post"
          fill_in "Title", :with => "Test Title"
          fill_in "Location", :with => "Location String"
    	    fill_in "Description", :with => "Test Description"
    	    click_button "Create Post"
        end
        it "should save and display it" do
    	    expect(page).to have_content("Test Title")
    	    expect(page).to have_content("Test Description")
    	    expect(page).to have_content("Location String")
        end
        context "When trying to edit a post" do
      	  before do
            visit root_path
            within("#displayed-groups") do
      	      click_link "Edit"
            end
      	  end
      	  context "should let you fill out new information" do
      	    before do
      		    fill_in "Description", :with => "New Description"
      		    click_button "Update Post"
      	    end
      	    it "should display the new information" do
      		    expect(page).to have_content("New Description") 
      	    end
      	  end
        end
        context "When trying to delete the post" do
      	  before do
            within("#displayed-groups") do
      	      click_link "Delete"
            end
      	  end
      	  it "should be deleted" do
      	    expect(Post.count).to eq 0
      	  end
        end
      end
    end
  end
  context "When not logged in" do
    context "when visiting the show view" do
      before do
        visit post_path(post)
      end
      context "when there are times set" do
        it "should display all the post information" do
          expect(page).to have_content(post.title)
          expect(page).to have_content(post.description)
          expect(page).to have_content(post.meeting_time.strftime(I18n.t('time.formats.default')))
          expect(page).to have_content(post.end_time.strftime(I18n.t('time.formats.default')))
          expect(page).to have_content(post.location)
        end
      end
      context "when there is no time set" do
        before do
          post.meeting_time = nil
          post.end_time = nil
          post.save
          visit post_path(post)
        end
        it "should display all proper information" do
          expect(page).to have_content(post.title)
          expect(page).to have_content(post.description)
          expect(page).to have_content("No Meeting Time Set")
          expect(page).to have_content("No Ending Time Set")
          expect(page).to have_content(post.location)
        end
      end
    end
  end
end
