# frozen_string_literal: true

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }
    it { is_expected.to be_able_to :read, Award }
    it { is_expected.to be_able_to :read, Link }
    it { is_expected.to be_able_to :read, Vote }

    it { is_expected.not_to be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe "for user" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:other_question) { create(:question, author: other_user) }
    let(:question) { create(:question, author: user) }
    let(:other_answer) { create(:answer, author: other_user, question: question) }
    let(:answer) { create(:answer, author: user, question: question) }

    it { is_expected.not_to be_able_to :manage, :all }
    it { is_expected.to be_able_to :read, :all }
    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.to be_able_to :create, Comment }

    it { is_expected.to be_able_to :update, create(:question, author: user), user: user }
    it { is_expected.not_to be_able_to :update, create(:question, author: other_user), user: user }

    it { is_expected.to be_able_to :update, create(:answer, author: user), user: user }
    it { is_expected.not_to be_able_to :update, create(:answer, author: other_user), user: user }

    it { is_expected.to be_able_to :destroy, create(:question, author: user), user: user }
    it { is_expected.not_to be_able_to :destroy, create(:question, author: other_user), user: user }

    it { is_expected.to be_able_to :destroy, create(:answer, author: user), user: user }
    it { is_expected.not_to be_able_to :destroy, create(:answer, author: other_user), user: user }

    context "assigning_as_best" do
      context "can best" do
        it { is_expected.to be_able_to :assigning_as_best, answer, author: user }
      end

      context "cannot make best" do
        before do
          answer.assign_best
        end

        it { is_expected.not_to be_able_to :assigning_as_best, answer, author: user }
      end
    end

    context "vote" do
      context "create_like" do
        it { is_expected.to be_able_to :create_like, other_question, user: user }
        it { is_expected.not_to be_able_to :create_like, question, user: user }
        it { is_expected.not_to be_able_to :create_like, other_question.like(user), user: user }

        it { is_expected.to be_able_to :create_like, other_answer, author: user }
        it { is_expected.not_to be_able_to :create_like, answer, user: user }
        it { is_expected.not_to be_able_to :create_like, other_answer.like(user), user: user }
      end

      context "create_dislike" do
        it { is_expected.to be_able_to :create_dislike, other_question, author: user }
        it { is_expected.not_to be_able_to :create_dislike, question, user: user }
        it { is_expected.not_to be_able_to :create_dislike, other_question.dislike(user), user: user }

        it { is_expected.to be_able_to :create_dislike, other_answer, user: user }
        it { is_expected.not_to be_able_to :create_dislike, answer, user: user }
        it { is_expected.not_to be_able_to :create_dislike, other_answer.dislike(user), user: user }
      end

      context "deselecting" do
        context "user can un rating " do
          before do
            other_question.dislike(user)
            other_answer.dislike(user)
          end

          it { is_expected.to be_able_to :delete_vote, other_question, user: user }
          it { is_expected.not_to be_able_to :delete_vote, question, user: user }
          it { is_expected.to be_able_to :delete_vote, other_answer, user: user }
          it { is_expected.not_to be_able_to :delete_vote, answer, user: user }
        end
      end
    end

    context "destroy attachment" do
      let(:question) { create(:question, :with_file, author: user) }
      let(:attachment) { question.files.first }
      let(:answer) { create(:answer, :with_file, author: other_user) }
      let(:other_attachment) { answer.files.first }

      it { is_expected.to be_able_to :destroy, attachment, user: user }
      it { is_expected.not_to be_able_to :destroy, other_attachment, user: user }
    end

    context "Link" do
      let(:link) { create(:link, linkable: question) }
      let(:link_other) { create(:link, linkable: other_question) }

      it { is_expected.to be_able_to :destroy, link }
      it { is_expected.not_to be_able_to :destroy, link_other }
    end

    context "User" do
      it { is_expected.to be_able_to :me, User }
    end

    context "Subscription" do
      it { is_expected.to be_able_to :create, Subscription }
      it { is_expected.to be_able_to :destroy, Subscription }
    end
  end
end
