# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include PgSearch::Model
  pg_search_scope :search_by_full_name, against: %i[email], using: {
    tsearch: {
      prefix: true
    }
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github facebook]

  has_many :questions, foreign_key: "author_id", dependent: :destroy
  has_many :answers, foreign_key: "author_id", dependent: :destroy
  has_many :awards
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author_of?(obj)
    obj.author_id == id
  end

  def voted?(resource)
    votes.exists?(voteable: resource)
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
