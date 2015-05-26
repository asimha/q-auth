require 'rails_helper'

describe Public::UserSessionsController, :type => :controller do

  let(:active_user) {FactoryGirl.create(:active_user)}
  let(:inactive_user) {FactoryGirl.create(:inactive_user)}
  let(:suspended_user) {FactoryGirl.create(:suspended_user)}

  describe "sign_in" do
    it "should display the sign in form" do
      get :sign_in, {}, {}
      expect(response.status).to eq(200)
    end
  end

  describe "create_session" do

    context "positive case" do
      it "should create session with email" do
        sign_in_params = { login_handle: active_user.email, password: active_user.password }
        post :create_session, sign_in_params, {}
        expect(session[:id].to_s).to  eq(active_user.id.to_s)
      end

      it "should create session with username" do
        sign_in_params = { login_handle: active_user.username, password: active_user.password }
        post :create_session, sign_in_params, {}
        expect(session[:id].to_s).to  eq(active_user.id.to_s)
      end
    end

    context "negative case" do
      it "invalid email" do
        sign_in_params = { login_handle: "invalid@email.com" }
        session[:id] = nil
        post :create_session, sign_in_params, {}
        expect(session[:id]).to be_nil
      end

      it "invalid password" do
        sign_in_params = { login_handle: active_user.email, password: "Invalid" }
        session[:id] = nil
        post :create_session, sign_in_params, {}
        expect(session[:id]).to be_nil
      end

      it "inactive user" do
        sign_in_params = { login_handle: inactive_user.email, password: inactive_user.password }
        session[:id] = nil
        post :create_session, sign_in_params, {}
        expect(session[:id]).to be_nil
      end

      it "suspended user" do
        sign_in_params = { login_handle: suspended_user.email, password: suspended_user.password }
        session[:id] = nil
        post :create_session, sign_in_params, {}
        expect(session[:id]).to be_nil
      end
    end
  end

  describe "destroy a session" do
    it "should delete session of user" do
      delete :sign_out, {:id => active_user.id}, {id: active_user.id}
      expect(response).to redirect_to("/sign_in?")
    end
  end
end
