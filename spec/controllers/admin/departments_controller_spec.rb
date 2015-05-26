require 'rails_helper'

describe Admin::DepartmentsController, :type => :controller do

  let(:super_admin_user) {FactoryGirl.create(:super_admin_user)}
  let(:department_1) {FactoryGirl.create(:department)}
  let(:department_2) {FactoryGirl.create(:department)}

  let(:valid_department_params) { {department: FactoryGirl.build(:department).as_json} }
  let(:invalid_department_params) { {department: {}} }

  context "index" do
    it "should return the list of departments" do
      [department_1,department_2]
      get :index, nil, {id: super_admin_user.id}
      expect(assigns[:departments]).to match_array([department_1,department_2])
      expect(response.status).to eq(200)

      xhr :get, :index, {}, {id: super_admin_user.id}
      expect(assigns[:departments]).to match_array([department_1,department_2])
      expect(response.code).to eq("200")
    end
  end

  context "show" do
    it "should return a specific department" do
      get :show, {:id => department_1.id}, {id: super_admin_user.id}
      expect(assigns[:department]).to eq(department_1)
      expect(assigns[:departments]).to match_array([department_1,department_2])
      expect(response.status).to eq(200)

      xhr :get, :show, {id: department_1.id}, {id: super_admin_user.id}
      expect(assigns[:department]).to eq(department_1)
      expect(response.code).to eq("200")
    end
  end

  context "new" do
    it "should display the form" do
      get :new, {}, {id: super_admin_user.id}
      expect(response.status).to eq(200)

      xhr :get, :new, {}, {id: super_admin_user.id}
      expect(assigns(:department)).to be_a Department
    end
  end

  context "create" do
    it "positive case" do
      xhr :post, :create, valid_department_params, {id: super_admin_user.id}
      expect(Department.count).to  eq 1
      expect(response.code).to eq("200")
    end

    it "negative case" do
      xhr :post, :create, invalid_department_params, {id: super_admin_user.id}
      expect(Department.count).to  eq 0
      expect(response.code).to eq("200")
    end
  end

  context "edit" do
    it "should display the form" do
      get :edit, {id: department_1.id}, {id: super_admin_user.id}
      expect(assigns[:department]).to eq(department_1)
      expect(response.status).to eq(200)

      xhr :get, :edit, {id: department_1.id}, {id: super_admin_user.id}
      expect(assigns(:department)).to eq(department_1)
      expect(response.code).to eq("200")
    end
  end

  context "update" do
    it "positive case" do
      xhr :put, :update, {id: department_1.id, department: department_1.as_json.merge!({"name" =>  "Updated Department Name"})}, {id: super_admin_user.id}
      expect(assigns(:department).errors.any?).to eq(false)
      expect(assigns(:department).name).to  eq("Updated Department Name")
      expect(Department.count).to  eq 1
      expect(response.code).to eq("200")
    end

    it "negative case" do
      xhr :put, :update, {id: department_1.id, department: department_1.as_json.merge!({"name" =>  ""})}, {id: super_admin_user.id}
      expect(assigns(:department).errors.any?).to eq(true)
      expect(Department.count).to  eq 1
      expect(response.code).to eq("200")
    end
  end

  context "destroy" do
    it "should remove the department" do
      [department_1, department_2]
      xhr :delete, :destroy, {id: department_1.id}, {id: super_admin_user.id}
      expect(Department.count).to  eq 1
      expect(response.code).to eq("200")
    end
  end

end