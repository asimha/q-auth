require "rails_helper"

RSpec.feature "Dashboard", :type => :feature do

  before(:each) do
    extend LoginSpecHelper
  end

  scenario "User visits dashboard" do
    login_as_an_active_user
    expect(current_url).to eq users_dashboard_url
    expect(page).to have_content("Signed In: You have successfully signed in")
    expect(page).to have_content("Dashboard")
  end

  scenario "Admin visits dashboard" do
    login_as_an_admin_user
    expect(current_url).to eq users_dashboard_url
    expect(page).to have_content("Signed In: You have successfully signed in")
    expect(page).to have_content("Dashboard")
  end

end


