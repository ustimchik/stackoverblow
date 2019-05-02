require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:user).optional }
  it { should belong_to(:question) }

  it { should validate_presence_of :name }
  it { is_expected.to validate_attachment_of(:image) }
  it { is_expected.to allow_content_types("image/png", "image/jpeg").for(:image) }
  it { is_expected.not_to allow_content_type("image/gif").for(:image) }
end