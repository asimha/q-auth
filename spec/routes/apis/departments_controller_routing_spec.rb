require "rails_helper"

describe Api::V1::DepartmentsController, :type => :controller do
  it "index" do
    expect(:get => "/api/v1/departments").to route_to(
      :controller => "api/v1/departments",
      :action => "index"
    )
  end

  it "show" do
    expect(:get => "/api/v1/department/:id").to route_to(
      :controller => "api/v1/departments",
      :action => "show",
      :id=> ":id"
    )
  end
end
