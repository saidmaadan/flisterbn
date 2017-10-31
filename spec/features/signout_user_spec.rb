require "rails_helper"

RSpec.feature "Signing users out" do
  before do
    @user = User.create!(first_name: "Said", last_name: "Fola", email: "said@example.com", password: "password")

    visit '/'

    click_link "Sign in"
    fill_in "Email", with: @user.email
    fill_in "Password",  with: @user.password
    click_button "Log in"
  end

  scenario do
    visit "/"

    click_link "Sign out"

    expect(page).to have_content("Signed out successfully.")
  end
end
