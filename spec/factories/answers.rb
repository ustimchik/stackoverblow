FactoryBot.define do
  sequence :body do |n|
    "body#{n}"
  end
  factory :answer do
    question
    body
    trait :invalid do
      body { nil }
    end
  end
end