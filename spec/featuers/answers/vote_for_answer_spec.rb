# frozen_string_literal: true

describe "User can vote for the answer he likes", "
  In order to to increase the answer rating
  As an authenticated user
  I'd like to be able to up rating for answer
" do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:answer) { create(:answer, question: question, author: user) }

  describe "not owner question" do
    before do
      sign_in(user2)
      visit question_path(question)
    end

    it "to vote like only once", js: true do
      within ".answers" do
        click_on "like"

        expect(page).to have_content "Answer like: 1"
        expect(page).not_to have_link "like"
        expect(page).not_to have_link "dislike"
      end
    end

    it "to vote is not enjoyed only once", js: true do
      within ".answers" do
        click_on "dislike"

        expect(page).to have_content "Answer like: -1"
        expect(page).not_to have_link "like"
        expect(page).not_to have_link "dislike"
      end
    end

    it "cancel rating", js: true do
      within ".answers" do
        click_on "dislike"
        click_on "deselecting"

        expect(page).to have_content "Answer like: 0"
        expect(page).not_to have_link "deselecting"
      end
    end
  end

  describe "owner question" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it "can not change rating" do
      within ".answers" do
        expect(page).not_to have_link "like"
        expect(page).not_to have_link "dislike"
      end
    end
  end
end
