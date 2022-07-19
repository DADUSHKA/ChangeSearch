# frozen_string_literal: true

describe "Subscribe to question" do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe "other user" do
    before do
      sign_in(other_user)
      visit question_path(question)
    end

    it "User can subscribe for a question" do
      click_on "Subscribe"

      expect(page).to have_content "You subscribed."
      expect(page).not_to have_link "Subscribe"
      expect(page).to have_link "Unsubscribe"
    end

    it "User can unsubscribe from a question" do
      click_on "Subscribe"
      click_on "Unsubscribe"

      expect(page).to have_content "You unsubscribed."
      expect(page).not_to have_link "Unubscribe"
      expect(page).to have_link "Subscribe"
    end
  end

  describe "author of the question" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it "User can not subscribe for a question" do
      expect(page).not_to have_link "Subscribe"
      expect(page).to have_link "Unsubscribe"
    end

    it "User can unsubscribe from the own question" do
      click_on "Unsubscribe"

      expect(page).to have_content "You unsubscribed."
      expect(page).not_to have_link "Unubscribe"
      expect(page).to have_link "Subscribe"
    end
  end
end
