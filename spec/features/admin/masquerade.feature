require "rails_helper"

RSpec.feature "Masquerade", :type => :feature do

  before(:each) do
    extend LoginSpecHelper
  end

  scenario "User visits dashboard" do

    login_as_an_admin_user
    expect(current_url).to eq users_dashboard_url
    user = FactoryGirl.create(:normal_user)
    visit admin_user_url(user)
    click_link('Masquerade')

    expect(current_url).to eq users_dashboard_url
    expect(page).to have_content("You have successfully signed in as #{user.name}")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content(user.name)

    within(:css, '#div_page_header') {
      click_link('Sign Out')
    }

    expect(current_url).to eq users_dashboard_url
    expect(page).to have_content("You have successfully signed in back as #{@current_admin.name}")
    expect(page).to have_content("Dashboard")
    expect(page).to have_content(@current_admin.name)

  end

end


