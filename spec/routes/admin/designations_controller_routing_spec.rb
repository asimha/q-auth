require "rails_helper"

describe Admin::DesignationsController, :type => :controller do

  let(:designation) {FactoryGirl.create(:designation)}

  it "index" do
    expect(:get => admin_designations_path).to route_to(:action => 'index', :controller => 'admin/designations')
  end

  it "show" do
    expect(:get => admin_designation_path(designation)).to route_to(:action => 'show', :controller => 'admin/designations', :id => designation.id.to_s)
  end

  it "new" do
    expect(:get => new_admin_designation_path).to route_to(:action => 'new', :controller => 'admin/designations')
  end

  it "create" do
    expect(:post => admin_designations_path).to route_to(:action => 'create', :controller => 'admin/designations')
  end

  it "edit" do
    expect(:get => edit_admin_designation_path(designation)).to route_to(:action => 'edit', :controller => 'admin/designations', :id => designation.id.to_s)
  end

  it "update" do
    expect(:put => admin_designation_path(designation)).to route_to(:action => 'update', :controller => 'admin/designations', :id => designation.id.to_s)
  end

  it "destroy" do
    expect(:delete => admin_designation_path(designation)).to route_to(:action => 'destroy', :controller => 'admin/designations', :id => designation.id.to_s)
  end
end