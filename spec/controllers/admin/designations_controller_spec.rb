require 'rails_helper'

describe Admin::DesignationsController, :type => :controller do

  let(:super_admin_user) {FactoryGirl.create(:super_admin_user)}
  let(:designation_1) {FactoryGirl.create(:designation)}
  let(:designation_2) {FactoryGirl.create(:designation)}

  let(:valid_designation_params) { {designation: FactoryGirl.build(:designation).as_json} }
  let(:invalid_designation_params) { {designation: {}} }

  context "index" do
    it "should return the list of designations" do
      [designation_1,designation_2]
      get :index, nil, {id: super_admin_user.id}
      expect(assigns[:designations]).to match_array([designation_1,designation_2])
      expect(response.status).to eq(200)

      xhr :get, :index, {}, {id: super_admin_user.id}
      expect(assigns[:designations]).to match_array([designation_1,designation_2])
      expect(response.code).to eq("200")
    end
  end

  context "show" do
    it "should return a specific designation" do
      get :show, {:id => designation_1.id}, {id: super_admin_user.id}
      expect(assigns[:designation]).to eq(designation_1)
      expect(assigns[:designations]).to match_array([designation_1,designation_2])
      expect(response.status).to eq(200)

      xhr :get, :show, {id: designation_1.id}, {id: super_admin_user.id}
      expect(assigns[:designation]).to eq(designation_1)
      expect(response.code).to eq("200")
    end
  end

  context "new" do
    it "should display the form" do
      get :new, {}, {id: super_admin_user.id}
      expect(response.status).to eq(200)

      xhr :get, :new, {}, {id: super_admin_user.id}
      expect(assigns(:designation)).to be_a Designation
    end
  end

  context "create" do
    it "positive case" do
      xhr :post, :create, valid_designation_params, {id: super_admin_user.id}
      expect(Designation.count).to  eq 1
      expect(response.code).to eq("200")
    end

    it "negative case" do
      xhr :post, :create, invalid_designation_params, {id: super_admin_user.id}
      expect(Designation.count).to  eq 0
      expect(response.code).to eq("200")
    end
  end

  context "edit" do
    it "should display the form" do
      get :edit, {id: designation_1.id}, {id: super_admin_user.id}
      expect(assigns[:designation]).to eq(designation_1)
      expect(response.status).to eq(200)

      xhr :get, :edit, {id: designation_1.id}, {id: super_admin_user.id}
      expect(assigns(:designation)).to eq(designation_1)
      expect(response.code).to eq("200")
    end
  end

  context "update" do
    it "positive case" do
      xhr :put, :update, {id: designation_1.id, designation: designation_1.as_json.merge!({"title" =>  "Updated Designation Name"})}, {id: super_admin_user.id}
      expect(assigns(:designation).errors.any?).to eq(false)
      expect(assigns(:designation).title).to  eq("Updated Designation Name")
      expect(Designation.count).to  eq 1
      expect(response.code).to eq("200")
    end

    it "negative case" do
      xhr :put, :update, {id: designation_1.id, designation: designation_1.as_json.merge!({"title" =>  ""})}, {id: super_admin_user.id}
      expect(assigns(:designation).errors.any?).to eq(true)
      expect(Designation.count).to  eq 1
      expect(response.code).to eq("200")
    end
  end

  context "destroy" do
    it "should remove the designation" do
      [designation_1, designation_2]
      xhr :delete, :destroy, {id: designation_1.id}, {id: super_admin_user.id}
      expect(Designation.count).to  eq 1
      expect(response.code).to eq("200")
    end
  end

end