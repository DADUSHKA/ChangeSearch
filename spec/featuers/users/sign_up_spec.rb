# frozen_string_literal: true

describe "User can sign up", '
  In order to user the service
  User can sign up
' do
  it "User sign up" do
    visit new_user_registration_path
    fill_in "user_email", with: "user@mail.com"
    password = "12345678"
    fill_in "user_password", with: password
    fill_in "user_password_confirmation", with: password
    click_on "Sign up"

    expect(page).to have_current_path root_path, ignore_query: true
    expect(page).to have_content "Welcome! You have signed up successfully."
  end
end
