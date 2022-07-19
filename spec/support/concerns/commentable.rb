# frozen_string_literal: true

shared_examples_for "has many comments" do
  it { is_expected.to have_many(:comments).dependent(:destroy) }
end
