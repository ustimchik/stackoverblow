FactoryBot.define do
  factory :answer do
    question
    title { "MyString" }
    body { "MyText" }
    trait :invalid do
      title { nil }
    end
  end
end
