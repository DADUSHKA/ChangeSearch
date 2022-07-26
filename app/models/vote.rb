# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :voteable, polymorphic: true
  belongs_to :user

  validates :choice, presence: true
  validates :choice, inclusion: [-1, 0, 1]

  validates :user_id, uniqueness: { scope: %i[voteable_type voteable_id] }
end
