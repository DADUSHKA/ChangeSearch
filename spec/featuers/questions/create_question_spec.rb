# frozen_string_literal: true

describe "User can create question", "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  let(:user) { create(:user) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit questions_path
      click_on "Ask question"
    end

    it "asks a question" do
      fill_in "Title", with: "Test question"
      fill_in "Body", with: "text text text"
      click_on "Create"

      expect(page).to have_content "Your question successfully created."
      expect(page).to have_content "Test question"
      expect(page).to have_content "text text text"
    end

    it "asks a question with errors" do
      click_on "Create"

      expect(page).to have_content "Title can't be blank"
    end

    it "asks a question with attached file" do
      fill_in "Title", with: "Test question"
      fill_in "Body", with: "text text text"
      attach_file "File", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on "Create"

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  it "Unauthenticated user tries to ask a question" do
    visit questions_path
    expect(page).not_to have_link "Ask question"
  end

  context "multiple sessions" do
    it "on all questions' page user sees newly created by other user question", js: true do
      Capybara.using_session("user") do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session("guest") do
        visit questions_path
      end

      Capybara.using_session("user") do
        click_on "Ask question"

        fill_in "Title", with: "Test question"
        fill_in "Body", with: "text text text"
        click_on "Create"

        expect(page).to have_content "Your question successfully created."
        expect(page).to have_content "Test question"
        expect(page).to have_content "text text text"
      end

      Capybara.using_session("guest") do
        expect(page).to have_content "Test question"
      end
    end
  end
end
