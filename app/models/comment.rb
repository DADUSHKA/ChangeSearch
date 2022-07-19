# frozen_string_literal: true

class Comment < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_full_name, against: %i[body], using: {
    tsearch: {
      prefix: true,
    },
  }

  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true
end
