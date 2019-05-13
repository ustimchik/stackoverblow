require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :voteable }
  it { should belong_to :user }

  it 'validates score to match -1 or 1' do
    expect(subject).to validate_inclusion_of(:score).in_array([-1, 1])
  end
end