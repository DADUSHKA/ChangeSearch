# frozen_string_literal: true

describe "User can create comments for question", "
  In order to create comments to question
  As an authenticated user
  I'd like to be able to set comments for question
" do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it "give comment for question", js: true do
      within ".question" do
        # save_and_open_page
        click_on "Add comment"
        fill_in "Comment body", with: "My comment"
        click_on "Save comment"

        expect(page).not_to have_selector "#Question-comment-#{question.id}"
      end

      within ".question-comments" do
        expect(page).to have_content "My comment"
      end
    end

    context "multiple session" do
      it "comment appears on another user page", js: true do
        Capybara.using_session("user") do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session("quest") do
          visit question_path(question)
        end

        Capybara.using_session("user") do
          within ".question" do
            click_on "Add comment"
            fill_in "Comment body", with: "it comment"
            click_on "Save comment"

            expect(page).not_to have_selector "#Question-comment-#{question.id}"
          end

          within ".question-comments" do
            expect(page).to have_content "it comment"
          end
        end

        Capybara.using_session("quest") do
          within ".question-comments" do
            expect(page).to have_content "it comment"
          end
        end
      end
    end

    it "give comment with error", js: true do
      within ".question" do
        click_on "Add comment"
        click_on "Save comment"
      end

      within ".comment_errors" do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  it "Unauthenticated user tries set comment" do
    visit question_path(question)

    within ".question" do
      expect(page).not_to have_link "Add comment"
    end
  end
end
