# frozen_string_literal: true

describe "User can view a question and its answers", '
  User can view any questions and those answers
' do
  let(:question) { create(:question) }
  let(:answers) { create_list(:answer, 2, question: question) }

  it "User can view a question and its answers" do
    visit question_path(question)
    expect(page).to have_content(question.body)

    question.answers.each do |a|
      expect(page).to have_content(a.body)
    end
  end
end
