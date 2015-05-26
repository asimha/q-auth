require "rails_helper"

describe Users::DashboardController, :type => :controller do
  it "index" do
    expect(:get => "/users/dashboard").to route_to(
      :controller => "users/dashboard",
      :action => "index"
    )
  end
end