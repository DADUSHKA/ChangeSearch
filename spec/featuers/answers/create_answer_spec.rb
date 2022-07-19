# frozen_string_literal: true

describe "The user, while on the question page, can write the answer to the question", '
  To write an answer to a question
  As an authenticated user
  I would like to go to the question page
' do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    it "write the answer to the question", js: true do
      fill_in "Your answer", with: "text text text"
      click_on "Reply"

      expect(page).to have_current_path question_path(question), ignore_query: true
      expect(page).to have_content "Your answer successfully created."
      within ".answers" do
        expect(page).to have_content "text text text"
      end
    end

    it "write the answer with errors", js: true do
      click_on "Reply"

      expect(page).to have_content "Body can't be blank"
    end

    it "asks a answer with attached file", js: true do
      fill_in "Your answer", with: "text text text"

      attach_file "File", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on "Reply"

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  it "Unauthenticated user write the answer to the question" do
    visit question_path(question)
    expect(page).not_to have_link "Reply"
  end

  context "mulitple sessions", js: true do
    let(:github_url) { "https://github.com" }

    it "answer appears on another user's page" do
      Capybara.using_session("guest") do
        guest = create(:user)

        sign_in(guest)
        visit question_path(question)
      end

      Capybara.using_session("user") do
        sign_in(user)
        visit question_path(question)

        fill_in "Your answer", with: "text text text"
        attach_file "File", ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        within all(".nested-fields")[0] do
          fill_in "link-name", with: "My link"
          fill_in "Url", with: github_url
        end

        click_on "Reply"
        expect(page).to have_content "text text text"
        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
        expect(page).to have_link "My link", href: github_url
      end

      Capybara.using_session("guest") do
        expect(page).to have_content "text text text"
        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
        expect(page).to have_link "My link", href: github_url
      end
    end
  end
end
