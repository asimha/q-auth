require "rails_helper"

RSpec.feature "Sign In", :type => :feature do

  scenario "User visits home page" do
    visit root_url
    expect(page).to have_content "Sign In"
  end

  scenario "User sign in" do
    active_user = FactoryGirl.create(:active_user, email: "user@domain.com")
    visit sign_in_url
    expect(page).to have_content "Sign In"
    fill_in "Email", :with => active_user.email
    fill_in "Password", :with => ConfigCenter::Defaults::PASSWORD
    click_button "Sign In"
    expect(current_url).to eq users_dashboard_url
    expect(page).to have_content("Signed In: You have successfully signed in")
  end

  scenario "User sign in with wrong password" do
    active_user = FactoryGirl.create(:active_user, email: "user@domain.com")
    visit sign_in_url
    expect(page).to have_content "Sign In"
    fill_in "Email", :with => active_user.email
    fill_in "Password", :with => "invalid"
    click_button "Sign In"
    expect(page).to have_content("Invalid Login: Invalid Username/Email or password.")
  end

  scenario "User sign in with wrong email" do
    active_user = FactoryGirl.create(:active_user, email: "user@domain.com")
    visit sign_in_url
    expect(page).to have_content "Sign In"
    fill_in "Email", :with => "invalidemail"
    click_button "Sign In"
    expect(page).to have_content("Invalid Login: Invalid Username/Email or password.")
  end

  scenario "Inactive User sign in with wrong email" do
    inactive_user = FactoryGirl.create(:inactive_user, email: "user@domain.com")
    visit sign_in_url
    expect(page).to have_content "Sign In"
    fill_in "Email", :with => inactive_user.email
    fill_in "Password", :with => ConfigCenter::Defaults::PASSWORD
    click_button "Sign In"
    expect(page).to have_content("Account Inactive: Your account is not yet approved, please contact administrator to activate your account")
  end

  scenario "Suspended User sign in with wrong email" do
    suspended_user = FactoryGirl.create(:suspended_user, email: "user@domain.com")
    visit sign_in_url
    expect(page).to have_content "Sign In"
    fill_in "Email", :with => suspended_user.email
    fill_in "Password", :with => ConfigCenter::Defaults::PASSWORD
    click_button "Sign In"
    expect(page).to have_content("Account Suspended: Your account is suspended, please contact administrator")
  end

end


