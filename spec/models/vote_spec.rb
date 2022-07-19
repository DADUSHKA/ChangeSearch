# frozen_string_literal: true

RSpec.describe Vote, type: :model do
  it { is_expected.to belong_to(:voteable) }
  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:choice) }
  it { is_expected.to validate_inclusion_of(:choice).in_range(-1..1) }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:voteable_type, :voteable_id) }
end
