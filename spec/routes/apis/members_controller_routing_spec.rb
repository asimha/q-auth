require "rails_helper"

describe Api::V1::MembersController, :type => :controller do
  it "index" do
    expect(:get => "/api/v1/members").to route_to(
      :controller => "api/v1/members",
      :action => "index"
    )
  end

  it "show" do
    expect(:get => "/api/v1/members/1").to route_to(
      :controller => "api/v1/members",
      :action => "show",
      :id => "1"
    )
  end
end