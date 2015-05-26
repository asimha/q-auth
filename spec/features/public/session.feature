require "rails_helper"

RSpec.feature "Sign In", :type => :feature do

  before(:each) do
    extend LoginSpecHelper
  end

  scenario "User visits dashboard with expired session" do
    login_as_an_active_user
    expire_session
    visit users_dashboard_url
    expect(current_url).to eq sign_in_url
    expect(page).to have_content("Session Expired: Your session has been expired. Please sign in again")
    expect(page).to have_content("Sign In")
  end

end


