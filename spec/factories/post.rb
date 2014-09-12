FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Group Title Number #{n}" }
    description "Description Text"
    location "location string"
    sequence(:meeting_time) { |n| DateTime.current.midnight + n.minutes }
    sequence(:end_time) { |n| DateTime.current.midnight + n.minutes }
    recipients nil
    onid "blah"

    trait :with_recipient do
      after(:build) do |post|
        post.recipients = "test@test.com"
      end
    end
    trait :with_location do
      after(:build) do |post|
        @location = build(:location)
        post.location = @location.location
        @location.save
        post.save
      end
    end
  end
end
