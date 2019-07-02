FactoryBot.define do
  factory :comment do
    user
    body { "Comment body" }
    trait :invalid do
      body { nil }
    end
  end
end