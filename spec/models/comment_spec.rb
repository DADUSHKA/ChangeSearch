# frozen_string_literal: true

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to(:commentable) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:body) }
end
