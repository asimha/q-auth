require "rails_helper"

describe Admin::UsersController, :type => :controller do

  let(:user) {FactoryGirl.create(:active_user)}

  it "index" do
    expect(:get => admin_users_path).to route_to(:action => 'index', :controller => 'admin/users')
  end

  it "show" do
    expect(:get => admin_user_path(user)).to route_to(:action => 'show', :controller => 'admin/users', :id => user.id.to_s)
  end

  it "new" do
    expect(:get => new_admin_user_path).to route_to(:action => 'new', :controller => 'admin/users')
  end

  it "create" do
    expect(:post => admin_users_path).to route_to(:action => 'create', :controller => 'admin/users')
  end

  it "edit" do
    expect(:get => edit_admin_user_path(user)).to route_to(:action => 'edit', :controller => 'admin/users', :id => user.id.to_s)
  end

  it "update" do
    expect(:put => admin_user_path(user)).to route_to(:action => 'update', :controller => 'admin/users', :id => user.id.to_s)
  end

  it "destroy" do
    expect(:delete => admin_user_path(user)).to route_to(:action => 'destroy', :controller => 'admin/users', :id => user.id.to_s)
  end

  it "make_admin" do
    expect(:put => make_admin_admin_user_path(user)).to route_to(:action => 'make_admin', :controller => 'admin/users', :id => user.id.to_s)
  end

  it "make_super_admin" do
    expect(:put => make_super_admin_admin_user_path(user)).to route_to(:action => 'make_super_admin', :controller => 'admin/users', :id => user.id.to_s)
  end

  it "remove_admin" do
    expect(:put => remove_admin_admin_user_path(user)).to route_to(:action => 'remove_admin', :controller => 'admin/users', :id => user.id.to_s)
  end

  it "remove_super_admin" do
    expect(:put => remove_super_admin_admin_user_path(user)).to route_to(:action => 'remove_super_admin', :controller => 'admin/users', :id => user.id.to_s)
  end

  it "update_status" do
    expect(:put => update_status_admin_user_path(user)).to route_to(:action => 'update_status', :controller => 'admin/users', :id => user.id.to_s)
  end
end