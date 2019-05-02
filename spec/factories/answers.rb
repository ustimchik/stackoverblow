include ActionDispatch::TestProcess

FactoryBot.define do
  sequence :body do |n|
    "body#{n}"
  end

  factory :answer do
    question
    user
    body
    trait :invalid do
      body { nil }
    end
    trait :with_attachment do
      after :create do |answer|
        file_path = Rails.root.join('spec', 'spec_helper.rb')
        file = fixture_file_upload(file_path, 'testfiles')
        answer.files.attach(file)
      end
    end
  end
end