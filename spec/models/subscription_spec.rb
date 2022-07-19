# frozen_string_literal: true

RSpec.describe Subscription, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:question) }

  it { is_expected.to have_db_index :question_id }
  it { is_expected.to have_db_index :user_id }
  it { is_expected.to have_db_index %i[user_id question_id] }

  it { is_expected.to validate_presence_of :question }
  it { is_expected.to validate_presence_of :user }
end
