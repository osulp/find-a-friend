FactoryGirl.define do
  factory :post do
    sequence(:title) { |n| "Group Title Number #{n}" }
    description "Description Text"
    location "Location Text"
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
        post.location = build(:location)
      end
    end
  end
end
