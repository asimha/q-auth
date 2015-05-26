require "rails_helper"

describe Api::V1::DesignationsController, :type => :controller do
  it "index" do
    expect(:get => "/api/v1/designations").to route_to(
      :controller => "api/v1/designations",
      :action => "index"
    )
  end

  it "show" do
    expect(:get => "/api/v1/designation/:id").to route_to(
      :controller => "api/v1/designations",
      :action => "show",
      :id=> ":id"
    )
  end
end