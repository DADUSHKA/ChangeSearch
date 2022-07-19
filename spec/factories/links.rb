# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { "My Link" }
    url { "https://github.com" }
    association :linkable
  end
end
