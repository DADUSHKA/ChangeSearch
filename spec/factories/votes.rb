# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    choice { 1 }
    user
    association :voteable, factory: :answer
  end
end
