# frozen_string_literal: true

describe "Logged in user can sign out", '
  In order to finish work
  logged in user can sign out
' do
  let(:user) { create(:user) }

  before { visit new_user_session_path }

  it "Logged in user can sign out" do
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
    expect(page).to have_current_path root_path, ignore_query: true
    expect(page).to have_content "Signed in successfully."

    click_on "Log out"
    expect(page).to have_current_path root_path, ignore_query: true
    expect(page).to have_content "Signed out successfully."
  end
end
