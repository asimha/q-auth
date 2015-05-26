require "rails_helper"

describe Users::ImagesController, :type => :controller do

  let(:image) {FactoryGirl.create(:picture)}

  it "index" do
    expect(:get => users_images_path).to route_to(:action => 'index', :controller => 'users/images')
  end

  it "show" do
    expect(:get => users_image_path(image)).to route_to(:action => 'show', :controller => 'users/images', :id => image.id.to_s)
  end

  it "new" do
    expect(:get => new_users_image_path).to route_to(:action => 'new', :controller => 'users/images')
  end

  it "create" do
    expect(:post => users_images_path).to route_to(:action => 'create', :controller => 'users/images')
  end

  it "edit" do
    expect(:get => edit_users_image_path(image)).to route_to(:action => 'edit', :controller => 'users/images', :id => image.id.to_s)
  end

  it "update" do
    expect(:put => users_image_path(image)).to route_to(:action => 'update', :controller => 'users/images', :id => image.id.to_s)
  end

  it "destroy" do
    expect(:delete => users_image_path(image)).to route_to(:action => 'destroy', :controller => 'users/images', :id => image.id.to_s)
  end
end