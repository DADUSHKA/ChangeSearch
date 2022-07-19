# frozen_string_literal: true

describe "User can edit his question", "
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
" do
  let!(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:question) { create(:question, author: user1) }
  let!(:question1) { create(:question, :with_file, author: user) }
  let(:github_url) { "https://github.com" }

  it "Unauthenticated can not edit question" do
    visit questions_path

    expect(page).not_to have_link "Edit question"
  end

  describe "Authenticated user", js: true do
    before do
      sign_in(user)
      visit questions_path
      expect(page).to have_content question1.title
      click_on "Edit question"
    end

    it "edits his question" do
      fill_in "Your question", with: "edited question"
      click_on "Save"

      expect(page).not_to have_content question1.title
      expect(page).to have_content "edited question"
      expect(page).not_to have_selector "textarea"
      expect(page).to have_content "The question was updated successfully."
    end

    it "edits his question with errors" do
      fill_in "Your question", with: ""
      click_on "Save"

      expect(page).to have_content "Title can't be blank"
    end

    it "edits a question with attached file" do
      fill_in "Your question", with: "edited question"
      attach_file "File", ["#{Rails.root}/spec/rails_helper.rb"]

      click_on "Save"
      visit question_path(question1)

      expect(page).to have_link "test.pdf"
      expect(page).to have_link "rails_helper.rb"
    end

    it "delete an attached question file" do
      click_on "Save"
      click_on "Edit question"
      click_on "Delete this file"
      expect(page).not_to have_link "test.pdf"
    end

    it "adding a link when editing a question" do
      click_on "add link"

      within all(".nested-fields")[0] do
        fill_in "link-name", with: "My link"
        fill_in "Url", with: github_url
      end

      click_on "add link"

      within all(".nested-fields")[0] do
        fill_in "link-name", with: "My link2"
        fill_in "Url", with: github_url
      end

      click_on "Save"
      visit question_path(question1)

      expect(page).to have_link "My link", href: github_url
      expect(page).to have_link "My link2", href: github_url
    end
  end

  it "can remove the link from your question", js: true do
    link = create(:link, linkable: question1)

    sign_in(user)
    visit question_path(question1)
    expect(page).to have_link "My Link", href: github_url

    click_on "Delete link"

    expect(page).not_to have_link "My link", href: github_url
  end

  it "tries to edit other user's question" do
    sign_in(user)
    visit questions_path
    expect(page).to have_no_link("Edit", href: question_path(question))
  end
end
