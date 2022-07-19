# frozen_string_literal: true

describe "User can create comment for answer", "
  In order to create comment to answer
  As an authenticated user
  I'd like to be able to set comment for answer
" do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it "give comment for answer", js: true do
      within ".answers" do
        click_on "Add comment"
        fill_in "Comment body", with: "My answer comment"
        click_on "Save comment"

        expect(page).not_to have_selector "#Answer-comment-#{answer.id}"
      end

      within ".answer-comments-#{answer.id}" do
        expect(page).to have_content "My answer comment"
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
          within ".answers" do
            click_on "Add comment"
            fill_in "Comment body", with: "it comment"
            click_on "Save comment"

            expect(page).not_to have_selector "#Answer-comment-#{answer.id}"
          end

          within ".answer-comments-#{answer.id}" do
            expect(page).to have_content "it comment"
          end
        end

        Capybara.using_session("quest") do
          within ".answer-comments-#{answer.id}" do
            expect(page).to have_content "it comment"
          end
        end
      end
    end

    it "give comment with error", js: true do
      within ".answers" do
        click_on "Add comment"
        click_on "Save comment"

        expect(page).not_to have_selector "#Answer-comment-#{answer.id}"
      end

      within ".comment_errors" do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  it "Unauthenticated user tries set comment" do
    visit question_path(question)

    within ".answers" do
      expect(page).not_to have_link "Add comment"
    end
  end
end
