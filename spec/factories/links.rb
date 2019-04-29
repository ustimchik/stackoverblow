FactoryBot.define do
  factory :link do
    name { "Test link" }
    url { "https://go.teachbase.ru/sessions/93683/tasks/35814" }

    trait :gist do
      url { "https://gist.github.com/ustimchik/62de74c20d955de75e273f2321952348" }
    end
  end
end