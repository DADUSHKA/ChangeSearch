# frozen_string_literal: true

module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :delete_all, as: :voteable
  end

  def like(user)
    change_rating(user, 1)
  end

  def dislike(user)
    change_rating(user, -1)
  end

  def deselecting(user)
    votes.find_by(user_id: user.id).delete if user.voted?(self) && !user.author_of?(self)
  end

  def choice
    votes.sum(:choice)
  end

  private

  def change_rating(user, option)
    votes.create(choice: option, user_id: user.id) if !user.voted?(self) && !user.author_of?(self)
  end
end
