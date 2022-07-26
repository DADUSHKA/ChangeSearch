# frozen_string_literal: true

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:awards) }
  it { is_expected.to have_many(:votes) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:authorizations).dependent(:destroy) }
  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }

  describe "Author_of?" do
    let!(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:users_question) { create(:question, author_id: user.id) }

    it "user is the author of the question" do
      expect(user).to be_author_of(users_question)
    end

    it "user is not author of the question" do
      expect(user).not_to be_author_of(question)
    end
  end

  describe "Voted?" do
    let(:not_voted_user) { create(:user) }
    let(:voted_user) { create(:user) }
    let(:author_reply) { create(:user) }

    let(:answer) { create(:answer, author: author_reply) }
    let(:vote) { create(:vote, user_id: voted_user.id, voteable: answer) }
    let(:votes) { [] }

    it "user is the author of the vote" do
      votes << vote
      expect(voted_user).to be_voted(answer)
    end

    it "user is not author of the vote" do
      votes << vote
      expect(not_voted_user).not_to be_voted(answer)
    end
  end

  describe ".find_for_oauth" do
    let(:auth) { OmniAuth::AuthHash.new(provider: "facebook", uid: "123456") }
    let(:service) { double("Services::FindForOauth") }

    it "calls Services::FindForOauth" do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
