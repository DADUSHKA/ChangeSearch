# frozen_string_literal: true

describe "User can delete his answer", '
  As the user who created the response
  I want to delete it
' do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:question1) { create(:question, author: user1) }

  it "Authenticated user can delete his answer", js: true do
    sign_in(user)

    answer = create(:answer, question: question, author: user)

    visit question_path(question)
    expect(page).to have_content answer.body
    expect(page).to have_link("Delete", href: answer_path(answer))

    click_on "Delete"

    expect(page).to have_current_path question_path(question), ignore_query: true
    expect(page).to have_content "Answer was successfully deleted"
    expect(page).to have_no_content answer.body
  end

  it "Authenticated user can not delete another's answer" do
    sign_in(user)

    answer = create(:answer, question: question1)
    visit question_path(question1)
    expect(page).to have_no_link("Delete", href: answer_path(answer))
  end

  it "Non-authenticated user can not delete another's answer" do
    answer = create(:answer, question: question1)
    visit question_path(question)
    expect(page).to have_no_link("Delete", href: answer_path(answer))
  end
end
