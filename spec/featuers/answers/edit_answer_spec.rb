# frozen_string_literal: true

describe "User can edit his answer", "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
" do
  let!(:user) { create(:user) }
  let(:user1) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, :with_file, question: question, author: user) }
  let!(:answer1) { create(:answer, question: question, author: user1) }
  let(:github_url) { "https://github.com" }

  it "Unauthenticated can not edit answer" do
    visit question_path(question)

    expect(page).not_to have_link "Edit"
  end

  describe "Authenticated user", js: true do
    before do
      sign_in(user)
      visit question_path(question)
      click_on "Edit"
    end

    it "edits his answer" do
      within ".answers" do
        fill_in "Your answer", with: "edited answer"
        click_on "Save"

        expect(page).not_to have_content answer.body
        expect(page).to have_content "edited answer"
        expect(page).not_to have_selector "textarea"
        expect(page).to have_content "The answer was updated successfully."
      end
    end

    it "edits his answer with errors" do
      within ".answers" do
        fill_in "Your answer", with: ""
        click_on "Save"

        expect(page).to have_content "Body can't be blank"
      end
      within ".form-create-answer" do
        expect(page).not_to have_content "Body can't be blank"
      end
    end

    it "edits a answer with attached file" do
      within ".answers" do
        attach_file "File", ["#{Rails.root}/spec/rails_helper.rb"]
        click_on "Save"
      end

      expect(page).to have_link "test.pdf"
      expect(page).to have_link "rails_helper.rb"
    end

    it "adding a link when editing a answer" do
      within ".answers" do
        click_on "add link"
      end

      within all(".nested-fields")[0] do
        fill_in "link-name", with: "My link"
        fill_in "Url", with: github_url
      end

      within ".answers" do
        click_on "add link"
      end

      within all(".nested-fields")[1] do
        fill_in "link-name", with: "My link2"
        fill_in "Url", with: github_url
      end

      click_on "Save"

      expect(page).to have_link "My link", href: github_url
      expect(page).to have_link "My link2", href: github_url
    end

    it "delete an attached question file" do
      within ".answers" do
        click_on "Delete this file"
        expect(page).not_to have_link "test.pdf"
      end
    end
  end

  it "can remove the link from your answer", js: true do
    link = create(:link, linkable: answer)

    sign_in(user)
    visit question_path(question)
    expect(page).to have_link "My Link", href: github_url

    click_on "Delete link"

    expect(page).not_to have_link "My link", href: github_url
  end

  it "tries to edit other user's question" do
    sign_in(user)
    visit question_path(question)
    expect(page).to have_no_link("Edit", href: answer_path(answer1))
  end
end
