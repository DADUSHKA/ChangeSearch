# frozen_string_literal: true

FactoryBot.define do
  factory :award do
    sequence(:name) { |n| "Award name#{n}" }
    question
    user
  end
end
