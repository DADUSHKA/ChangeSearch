# frozen_string_literal: true

RSpec.describe Award, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:user).optional }

  it { is_expected.to validate_presence_of :name }

  it "have one attached image" do
    expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
