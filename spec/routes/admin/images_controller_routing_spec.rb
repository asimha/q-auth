require "rails_helper"

describe Admin::ImagesController, :type => :controller do

  let(:image) {FactoryGirl.create(:picture)}

  it "index" do
    expect(:get => admin_images_path).to route_to(:action => 'index', :controller => 'admin/images')
  end

  it "show" do
    expect(:get => admin_image_path(image)).to route_to(:action => 'show', :controller => 'admin/images', :id => image.id.to_s)
  end

  it "new" do
    expect(:get => new_admin_image_path).to route_to(:action => 'new', :controller => 'admin/images')
  end

  it "create" do
    expect(:post => admin_images_path).to route_to(:action => 'create', :controller => 'admin/images')
  end

  it "edit" do
    expect(:get => edit_admin_image_path(image)).to route_to(:action => 'edit', :controller => 'admin/images', :id => image.id.to_s)
  end

  it "update" do
    expect(:put => admin_image_path(image)).to route_to(:action => 'update', :controller => 'admin/images', :id => image.id.to_s)
  end

  it "destroy" do
    expect(:delete => admin_image_path(image)).to route_to(:action => 'destroy', :controller => 'admin/images', :id => image.id.to_s)
  end
end