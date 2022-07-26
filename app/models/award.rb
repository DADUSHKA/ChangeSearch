# frozen_string_literal: true

class Award < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :image

  validates :name, presence: true
end
