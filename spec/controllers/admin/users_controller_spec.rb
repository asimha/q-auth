require 'rails_helper'

describe Admin::UsersController, :type => :controller do

  let(:admin_user) {FactoryGirl.create(:admin_user)}
  let(:super_admin_user) {FactoryGirl.create(:super_admin_user)}
  let(:super_admin_user2) {FactoryGirl.create(:super_admin_user)}

  let(:user_1) {FactoryGirl.create(:normal_user)}
  let(:user_2) {FactoryGirl.create(:normal_user)}

  let(:normal_user) {FactoryGirl.create(:normal_user)}
  let(:inactive_user) {FactoryGirl.create(:inactive_user)}
  let(:active_user) {FactoryGirl.create(:active_user)}
  let(:suspended_user) {FactoryGirl.create(:suspended_user)}

  let(:valid_user_params) { {user: FactoryGirl.build(:normal_user).as_json} }
  let(:invalid_user_params) { {user: {}} }

  context "index" do
    it "should return the list of users" do
      arr = [user_1,user_2, admin_user]
      get :index, nil, {id: admin_user.id}
      expect(assigns[:users]).to match_array(arr)
      expect(response.status).to eq(200)

      xhr :get, :index, {}, {id: admin_user.id}
      expect(assigns[:users]).to match_array(arr)
      expect(response.code).to eq("200")
    end
  end

  context "show" do
    it "should return a specific user" do
      arr = [user_1,user_2, admin_user]
      get :show, {:id => user_1.id}, {id: admin_user.id}
      expect(assigns[:user]).to eq(user_1)
      expect(assigns[:users]).to match_array(arr)
      expect(response.status).to eq(200)

      xhr :get, :show, {id: user_1.id}, {id: admin_user.id}
      expect(assigns[:user]).to eq(user_1)
      expect(response.code).to eq("200")
    end
  end

  context "new" do
    it "should display the form" do
      arr = [user_1,user_2, admin_user]
      get :new, {}, {id: admin_user.id}
      expect(assigns[:users]).to match_array(arr)
      expect(response.status).to eq(200)

      xhr :get, :new, {}, {id: admin_user.id}
      expect(assigns(:user)).to be_a User
    end
  end

  context "create" do
    it "positive case" do
      xhr :post, :create, valid_user_params, {id: admin_user.id}
      expect(User.count).to  eq 2
      expect(response.code).to eq("200")
    end

    it "negative case" do
      xhr :post, :create, invalid_user_params, {id: admin_user.id}
      expect(User.count).to  eq 1
      expect(response.code).to eq("200")
    end
  end

  context "edit" do
    it "should display the form" do
      arr = [user_1,user_2, admin_user]
      get :edit, {id: user_1.id}, {id: admin_user.id}
      expect(assigns[:users]).to match_array(arr)
      expect(assigns[:user]).to eq(user_1)
      expect(response.status).to eq(200)

      xhr :get, :edit, {id: user_1.id}, {id: admin_user.id}
      expect(assigns(:user)).to eq(user_1)
      expect(response.code).to eq("200")
    end
  end

  context "update" do
    it "positive case" do
      xhr :put, :update, {id: user_1.id, user: user_1.as_json.merge!({"name" =>  "Updated Name"})}, {id: admin_user.id}
      expect(assigns(:user).errors.any?).to eq(false)
      expect(assigns(:user).name).to  eq("Updated Name")
      expect(response.code).to eq("200")
    end

    it "negative case" do
      xhr :put, :update, {id: user_1.id, user: user_1.as_json.merge!({"name" =>  ""})}, {id: admin_user.id}
      expect(assigns(:user).errors.any?).to eq(true)
      expect(response.code).to eq("200")
    end
  end

  context "destroy" do
    it "should remove the user" do
      xhr :delete, :destroy, {id: user_1.id}, {id: admin_user.id}
      expect(User.count).to  eq 1
      expect(response.code).to eq("200")
    end
  end

  context "change_status" do
    context "make_admin" do
      it "super admin should be able to upgrade a user to admin" do
        xhr :get, :make_admin, {:id => user_1.id}, {id: super_admin_user.id}
        expect(assigns[:user].user_type).to eq("admin")
        expect(response.code).to eq("200")
      end
    end

    context "make_super_admin" do
      it "super admin should be able to upgrade a user to super admin" do
        xhr :get, :make_super_admin, {:id => user_1.id}, {id: super_admin_user.id}
        expect(assigns[:user].user_type).to eq("super_admin")
        expect(response.code).to eq("200")
      end

      it "super admin should be able to upgrade an admin to super admin" do
        xhr :get, :make_super_admin, {:id => admin_user.id}, {id: super_admin_user.id}
        expect(assigns[:user].user_type).to eq("super_admin")
        expect(response.code).to eq("200")
      end
    end

    context "remove_admin" do
      it "super admin should be able to downgrade an admin to user" do
        xhr :get, :remove_admin, {:id => admin_user.id}, {id: super_admin_user.id}
        expect(assigns[:user].user_type).to eq("user")
        expect(response.code).to eq("200")
      end
    end

    context "remove_super_admin" do
      it "super admin should be able to downgrade a super admin to admin" do
        xhr :get, :remove_super_admin, {:id => super_admin_user2.id}, {id: super_admin_user.id}
        expect(assigns[:user].user_type).to eq("admin")
      end
    end
  end

  context "update_status" do
    context "activate" do
      it "admin should be able to activate an inactive user account" do
        xhr :get, :update_status, {:id => inactive_user.id, status: "active"}, {id: admin_user.id}
        expect(assigns[:user].status).to eq("active")
        expect(response.code).to eq("200")
      end

      it "admin should be able to activate an suspended user account" do
        xhr :get, :update_status, {:id => suspended_user.id, status: "active"}, {id: admin_user.id}
        expect(assigns[:user].status).to eq("active")
        expect(response.code).to eq("200")
      end
    end

    context "Inactivate" do
      it "admin should be able to inactivate an active user account" do
        xhr :get, :update_status, {:id => active_user.id, status: "inactive"}, {id: admin_user.id}
        expect(assigns[:user].status).to eq("inactive")
        expect(response.code).to eq("200")
      end
    end

    context "Suspend" do
      it "admin should be able to suspend an active user account" do
        xhr :get, :update_status, {:id => active_user.id, status: "suspended"}, {id: admin_user.id}
        expect(assigns[:user].status).to eq("suspended")
        expect(response.code).to eq("200")
      end
    end
  end

  context "Masquerade" do
    it "admin should be able to masquerade" do
      get :masquerade, {id: user_1.id}, {id: admin_user.id}
      expect(assigns[:user]).to eq(user_1)
      expect(session[:id]).to eq(user_1.id)
      expect(session[:last_user_id]).to eq(admin_user.id)
      expect(response.status).to eq(302)
    end
  end

end
