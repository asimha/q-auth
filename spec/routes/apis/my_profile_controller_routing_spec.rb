require "rails_helper"

describe Api::V1::MyProfileController, :type => :controller do
  it "my_profile" do
    expect(:get => "/api/v1/my_profile").to route_to(
      :controller => "api/v1/my_profile",
      :action => "my_profile"
    )
  end

  it "update" do
    expect(:put => "/api/v1/update_profile").to route_to(
      :controller => "api/v1/my_profile",
      :action => "update"
    )
  end
end