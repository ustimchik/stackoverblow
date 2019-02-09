FactoryBot.define do
  sequence :title do |n|
    "title#{n}"
  end
  sequence :body do |n|
    "body#{n}"
  end
  factory :answer do
    question
    title
    body
    trait :invalid do
      title { nil }
    end
  end
end
