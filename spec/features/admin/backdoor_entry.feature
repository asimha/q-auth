require "rails_helper"

RSpec.feature "Backdoor Entry", :type => :feature do

  before(:each) do
    extend LoginSpecHelper
  end

  scenario "User visits backdoor page" do

    user = FactoryGirl.create(:normal_user)

    visit backdoor_url
    expect(page).to have_content(user.name)

    click_link("#{user.name}")
    expect(current_url).to eq users_dashboard_url
    expect(page).to have_content("You have successfully signed in as #{user.name}")

    expect(page).to have_content("Dashboard")
    expect(page).to have_content(user.name)

    within(:css, '#div_page_header') {
      click_link('Sign Out')
    }

    expect(current_url).to eq sign_in_url
    expect(page).to have_content("You have successfully signed out")
    expect(page).to have_content("Email")
    expect(page).to have_content("Password")

  end

end


