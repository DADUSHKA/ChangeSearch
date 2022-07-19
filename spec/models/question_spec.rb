# frozen_string_literal: true

RSpec.describe Question, type: :model do
  it { is_expected.to have_many(:answers).dependent(:delete_all) }
  it { is_expected.to have_many(:links).dependent(:delete_all) }
  it { is_expected.to have_one(:award).dependent(:destroy) }
  it { is_expected.to belong_to(:author) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }
  it { is_expected.to accept_nested_attributes_for :award }

  it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
  it { is_expected.to have_many(:subscribers).through(:subscriptions).source(:user) }

  it "have many attached file" do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe "voteable" do
    let(:user) { create(:user) }
    let(:question) { create :question, author: user }

    it_behaves_like "voteable", "question"
  end

  describe "commentable" do
    it_behaves_like "has many comments"
  end

  it "broadcast_question after create" do
    question_broadcast_data = "Prepared question hash for broadcasting"
    question = build(:question)
    expect(question).to receive(:broadcast_question).and_return(
      ActionCable.server.broadcast("all_questions", data: question_broadcast_data)
    )
    question.save
  end

  describe "reputation" do
    let(:question) { build(:question) }

    it "call ReputationJob" do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe "#subscribe" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, author: user) }

    it "after create question the author automatically subscribes" do
      expect(question.subscribers).to include user
    end

    it "subscribe other user" do
      question.subscribe(other_user)

      expect(question.subscribers).to include other_user
    end
  end

  describe "#unsubscribe" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, author: user) }

    before { question.subscribe(other_user) }

    it "unsubscribe from question" do
      question.unsubscribe(other_user)

      expect(question.subscribers).not_to include other_user
    end
  end
end
