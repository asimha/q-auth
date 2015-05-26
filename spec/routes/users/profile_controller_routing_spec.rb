require "rails_helper"

describe Users::ProfileController, :type => :controller do
  it "index" do
    expect(:get => "/users/profile").to route_to(
      :controller => "users/profile",
      :action => "index"
    )
  end

  it "edit" do
    expect(:get => "/users/edit").to route_to(
      :controller => "users/profile",
      :action => "edit"
    )
  end

  it "update" do
    expect(:put => "/users/update").to route_to(
      :controller => "users/profile",
      :action => "update"
    )
  end
end