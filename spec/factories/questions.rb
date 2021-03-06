FactoryBot.define do
  factory :question do
    title { "Question title" }
    body { "Question body" }
    user
    trait :invalid do
      title { nil }
    end
    trait :with_attachment do
      after :create do |question|
        file_path = Rails.root.join('spec', 'spec_helper.rb')
        file = fixture_file_upload(file_path, 'testfiles')
        question.files.attach(file)
      end
    end

    trait :with_award do
      after :create do |question|
        image = fixture_file_upload("#{Rails.root}/app/assets/images/test_image.png")
        award = Award.new(name: 'My award')
        award.image = image
        question.award = award
      end
    end

    factory :question_with_answers do
      # transient allows to pass data which is not attribute of the model for later use
      transient do
        answers_count { 5 }
      end

      # the after(:create) yields two values; the question instance itself and the evaluator,
      # which stores all values from the factory, including transient attributes;
      # so, when you create an item in specs, you can change answers_count
      # create(:question_with_answers, answers_count: 20)
      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end
end
