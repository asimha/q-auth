require "rails_helper"

describe WelcomeController, :type => :controller do
  it "root" do
    expect(:get => "/").to route_to(
      :controller => "public/user_sessions",
      :action => "sign_in"
    )
  end
end