# frozen_string_literal: true

require "sphinx_helper"

describe "user can search questions, answers, comments, users", "
  In order to get list of questions, answers, comments, users  from a community
  As an any user
  I'd like to be able search information
" do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question) do
    create(:question, author: user, title: "User Question",
                                                              body: "Question body")
  end
  let!(:another_question) do
    create(:question, author: another_user,
                  title: "Not_user Question_another", body: "Question body_another")
  end
  let!(:answer) do
    create(:answer, question: question, author: user,
                                                                body: "User answer")
  end
  let!(:another_answer) do
    create(:answer, question: another_question, author: another_user,
                                                        body: "User another_answer")
  end
  let!(:comment) do
    create(:comment, commentable: question, user: user,
                                                               body: "User comment")
  end
  let!(:another_comment) do
    create(:comment, commentable: question, user: another_user,
                                                           body: "Not_user comment")
  end

  before { visit root_path }

  it "search globally resourse", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within ".search" do
        fill_in "query", with: "User"
        select("Global search", from: "type")
        click_on "Search"
      end
      expect(page).to have_current_path search_path, ignore_query: true

      expect(page).to have_content "User answer"
      expect(page).to have_content "User another_answer"
      expect(page).to have_content "User comment"
      expect(page).to have_content "User Question"
      expect(page).not_to have_content "Not_user Question"
      expect(page).to have_content "User another_answer"
      expect(page).not_to have_content "Not_user comment"
    end
  end

  it "search globally user", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within ".search" do
        fill_in "query", with: question.author.email
        select("Global search", from: "type")
        click_on "Search"
      end
      expect(page).to have_current_path search_path, ignore_query: true

      expect(page).to have_content question.author.email
      expect(page).not_to have_content another_question.author.email
      expect(page).to have_content "User answer"
      expect(page).not_to have_content "User another_answer"
      expect(page).to have_content "User comment"
      expect(page).not_to have_content "Not_user comment"
      expect(page).to have_content "User Question"
      expect(page).not_to have_content "Not_user Question"
    end
  end

  it "search a question", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within ".search" do
        fill_in "query", with: "Question body"
        select("Question", from: "type")
        click_on "Search"
      end
      expect(page).to have_current_path search_path, ignore_query: true
      expect(page).to have_content "User Question"
      expect(page).not_to have_content "Not_user Question_another"
    end
  end

  it "search answer", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within ".search" do
        fill_in "query", with: "User answer"
        select("Answer", from: "type")
        click_on "Search"
      end
      expect(page).to have_current_path search_path, ignore_query: true
      expect(page).to have_content "User answer"
      expect(page).not_to have_content "User another_answer"
    end
  end

  it "search comment", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within ".search" do
        fill_in "query", with: "User comment"
        select("Comment", from: "type")
        click_on "Search"
      end
      expect(page).to have_current_path search_path, ignore_query: true
      expect(page).to have_content "User comment"
      expect(page).not_to have_content "Not_user comment"
    end
  end

  it "search users", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within ".search" do
        fill_in "query", with: question.author.email
        select("User", from: "type")
        click_on "Search"
      end
      expect(page).to have_current_path search_path, ignore_query: true
      expect(page).to have_content question.author.email
      expect(page).not_to have_content another_question.author.email
    end
  end

  it "search blank query", sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      within ".search" do
        fill_in "query", with: ""
        click_on "Search"
      end
      expect(page).to have_current_path search_path, ignore_query: true
      expect(page).to have_content "No results."
    end
  end
end
