# frozen_string_literal: true

describe "User can add rewards to question", '
  To mark the most useful answer
  As the author issue
  Can add a sign to give out a reward
' do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user2) }
  let!(:award) { create(:award, question: question) }

  it "User adds reward when asks question" do
    sign_in(user)
    visit new_question_path

    fill_in "Title", with: "Test question"
    fill_in "Body", with: "Test body"

    fill_in "Award name", with: "Award!"
    attach_file "File", "#{Rails.root}/spec/support/assets/award.png"

    click_on "Create"

    expect(page).to have_content "Question with the reward!"
  end

  it "The author of the question chooses the best answer to mark the author of the question", js: true do
    award.image.attach(io: File.open("#{Rails.root}/spec/support/assets/award.png"), filename: "award.png")

    sign_in(user)
    visit question_path(question)

    within(".answer-#{answer.id}") do
      click_on "Best answer"
    end
    click_on "Log out"

    sign_in(user2)
    visit awards_path

    expect(page).to have_content "Award name"
  end
end
