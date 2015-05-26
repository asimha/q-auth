require "rails_helper"

describe Users::MembersController, :type => :controller do
  it "index" do
    expect(:get => "/users/members").to route_to(
      :controller => "users/members",
      :action => "index"
    )
  end

  it "show" do
    expect(:get => "/users/member/:id").to route_to(
      :controller => "users/members",
      :action => "show",
      :id=> ":id"
    )
  end
end