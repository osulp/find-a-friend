# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    sequence(:onid) {|n| "testonid#{n}" }
  end
end
