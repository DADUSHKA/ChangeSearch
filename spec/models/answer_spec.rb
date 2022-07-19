# frozen_string_literal: true

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:author) }
  it { is_expected.to have_many(:links).dependent(:delete_all) }
  it { is_expected.to have_many(:votes) }

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }

  it "have many attached file" do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe "set the best answer" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:answer1) { create(:answer, question: question, author: user) }
    let!(:answer2) { create(:answer, question: question, author: user) }
    let!(:award) { create(:award, question: question) }

    it "set the best answer" do
      answer2.assign_best
      expect(answer2).to be_best
    end

    it "resets the best answer" do
      answer1.assign_best
      expect(answer1).to be_best
      answer2.assign_best
      answer1.reload
      expect(answer2).to be_best
      expect(answer1).not_to be_best
    end

    it "give award to author of answer" do
      expect { answer1.assign_best }.to change { user.awards.count }.by(1)
    end
  end

  describe "voteable" do
    let(:user) { create(:user) }
    let(:question) { create :question, author: user }
    let(:answer) { create(:answer, question: question, author: user) }

    it_behaves_like "voteable", "answer"
  end

  describe "commentable" do
    it_behaves_like "has many comments"
  end

  it "triggers :broadcast_answer on create & commit" do
    answer_broadcast_data = double("Prepared answer hash for broadcasting")
    question = create(:question)
    answer = build(:answer, question: question)
    expect(answer).to receive(:broadcast_answer).and_return(
      ActionCable.server.broadcast("question/#{question.id}/answers", data: answer_broadcast_data)
    )
    answer.save
  end
end
