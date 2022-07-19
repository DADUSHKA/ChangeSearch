# frozen_string_literal: true

describe "Author can choose the best answer", '
  As the author of the question
  I can choose the best answer
  To the question
' do
  let!(:user) { create(:user) }
  let!(:user1) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answer1) { create(:answer, question: question, author: user) }
  let!(:answer2) { create(:answer, question: question, author: user) }

  describe "Non authenticated user" do
    it "can not choose the best answer" do
      visit question_path(question)
      expect(page).not_to have_link "Best answer"
    end
  end

  describe "Authenticated user" do
    describe "is not the author of the question" do
      it "can not choose the best answer" do
        sign_in(user1)
        visit question_path(question)

        expect(page).not_to have_link "Best answer"
      end
    end

    describe "if he is the author of the question" do
      it "can choose the best answer", js: true do
        sign_in(user)
        visit question_path(question)

        within(".answer-#{answer1.id}") do
          click_on "Best answer"
          expect(page).to have_content "Best answer of all"
          expect(page).not_to have_link "Best answer"
        end
      end
    end

    it "can chose another answer as the best one", js: true do
      sign_in(user)
      visit question_path(question)

      within(".answer-#{answer1.id}") do
        click_on "Best answer"
      end

      within(".answer-#{answer2.id}") do
        click_on "Best answer"
        expect(page).to have_content "Best answer of all"
        expect(page).not_to have_link "Best answer"
        expect(page).not_to have_selector "textarea"
      end

      within(".answer-#{answer1.id}") do
        expect(page).to have_link "Best answer"
        expect(page).not_to have_content "Best answer of all"
        expect(page).not_to have_selector "textarea"
      end
    end

    it "the best answer should be the first in the list", js: true do
      sign_in(user)
      visit question_path(question)

      within(".answer-#{answer1.id}") do
        click_on "Best answer"
        expect(page).to have_content "Best answer of all"
        expect(page).not_to have_link "Best answer"
      end
      expect(first(".answers li").text).to have_content "Best answer of all"
    end
  end
end
