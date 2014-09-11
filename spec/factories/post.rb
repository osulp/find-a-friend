FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Group Title Number #{n}" }
    description "Description Text"
    location "location string"
    meeting_time DateTime.now
    end_time DateTime.now
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
