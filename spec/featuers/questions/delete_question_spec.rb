# frozen_string_literal: true

describe "User can delete his question or answer", '
  As the user who created the question
  I want to delete it
' do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:question1) { create(:question, author: user1) }

  it "Authenticated user can delete his question" do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content question.body
    expect(page).to have_content question.title

    click_on "Delete question"

    expect(page).to have_content "Question was successfully deleted"
    expect(page).to have_current_path questions_path, ignore_query: true
    expect(page).to have_no_content question.body
    expect(page).to have_no_content question.title
  end

  it "Authenticated user can not delete another's question" do
    sign_in(user)

    visit question_path(question1)
    expect(page).to have_content question.body
    expect(page).to have_content question.title
    expect(page).to have_no_link "Delete question"
  end

  it "Non-authenticated user can not delete another's question" do
    visit question_path(question)

    expect(page).to have_no_link("Delete question")
  end
end
