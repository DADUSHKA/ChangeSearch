# frozen_string_literal: true

describe "User is able to view questions list", '
  Any user is able to view question list
' do
  let(:user) { create(:user) }
  let!(:questions) { create_list(:question, 3) }

  it "User try to view existed questions list" do
    sign_in(user)
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  it "Not registered user is looking at a list of issues" do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
