require "rails_helper"

describe Admin::DepartmentsController, :type => :controller do

  let(:department) {FactoryGirl.create(:department)}

  it "index" do
    expect(:get => admin_departments_path).to route_to(:action => 'index', :controller => 'admin/departments')
  end

  it "show" do
    expect(:get => admin_department_path(department)).to route_to(:action => 'show', :controller => 'admin/departments', :id => department.id.to_s)
  end

  it "new" do
    expect(:get => new_admin_department_path).to route_to(:action => 'new', :controller => 'admin/departments')
  end

  it "create" do
    expect(:post => admin_departments_path).to route_to(:action => 'create', :controller => 'admin/departments')
  end

  it "edit" do
    expect(:get => edit_admin_department_path(department)).to route_to(:action => 'edit', :controller => 'admin/departments', :id => department.id.to_s)
  end

  it "update" do
    expect(:put => admin_department_path(department)).to route_to(:action => 'update', :controller => 'admin/departments', :id => department.id.to_s)
  end

  it "destroy" do
    expect(:delete => admin_department_path(department)).to route_to(:action => 'destroy', :controller => 'admin/departments', :id => department.id.to_s)
  end
end