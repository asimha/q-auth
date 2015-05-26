require "rails_helper"

RSpec.describe Api::V1::AuthenticationsController, :type => :controller do

  let!(:department) { FactoryGirl.create(:department, name: "Politics")}
  let!(:designation) { FactoryGirl.create(:designation, title: "Leader")}
  let!(:active_user) { FactoryGirl.create(:active_user,
                                            name: "Mohandas Gandhi",
                                            username: "mohandas",
                                            email: "mohandas@gandhi.com",
                                            phone: "1234567890",
                                            skype: "mohandas_skype",
                                            city: "Mysore",
                                            state: "Karnataka",
                                            country: "India",
                                            designation: designation,
                                            designation_overridden: "Leader of Opposition, Govt. India",
                                            department: department,
                                            linkedin: "mohandas_linkedin",
                                            biography: "Father of the nation, India") }
  describe "create" do
    context "Positive Case" do
      it "should return the user information with the for a valid auth token" do
        active_user
        #request.env['HTTP_AUTHORIZATION'] = token
        credentials = {login_handle: active_user.username, password: ConfigCenter::Defaults::PASSWORD}

        post "create", credentials, :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(true)
        expect(response_body["alert"]).to  eq("Signed In: You have successfully signed in")
        expect(response_body["data"]["name"]).to  eq("Mohandas Gandhi")
        expect(response_body["data"]["username"]).to  eq("mohandas")
        expect(response_body["data"]["email"]).to  eq("mohandas@gandhi.com")
        expect(response_body["data"]["phone"]).to  eq("1234567890")
        expect(response_body["data"]["skype"]).to  eq("mohandas_skype")
        expect(response_body["data"]["linkedin"]).to  eq("mohandas_linkedin")
        expect(response_body["data"]["city"]).to  eq("Mysore")
        expect(response_body["data"]["state"]).to  eq("Karnataka")
        expect(response_body["data"]["country"]).to  eq("India")
        expect(response_body["data"]["designation"]["title"]).to  eq("Leader")
        expect(response_body["data"]["designation_overridden"]).to  eq("Leader of Opposition, Govt. India")
        expect(response_body["data"]["department"]["name"]).to  eq("Politics")
        expect(response_body["data"]["user_type"]).to  eq("user")
        expect(response_body["data"]["biography"]).to  eq("Father of the nation, India")
        expect(response_body["data"]["auth_token"]).to  eq(active_user.auth_token)
        expect(response_body["data"]["password"]).to  eq(nil)
        expect(response_body["data"]["password_digest"]).to  eq(nil)
      end
    end

    context "Negative Case" do
      it "should return error for invalid username" do
        active_user
        credentials = {login_handle: active_user.username, password: "wrong password"}

        post "create", credentials, :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to  eq("Invalid Login: Invalid Username/Email or password.")
        expect(response_body["data"]["errors"]["name"]).to  eq("InvalidLoginError")
        expect(response_body["data"]["errors"]["description"]).to  eq("Invalid username/email or password.")
      end
      it "should return error for invalid password" do
        active_user
        credentials = {login_handle: "invalid username", password: ConfigCenter::Defaults::PASSWORD}

        post "create", credentials, :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(false)
        expect(response_body["alert"]).to  eq("Invalid Login: Invalid Username/Email or password.")
        expect(response_body["data"]["errors"]["name"]).to  eq("InvalidLoginError")
        expect(response_body["data"]["errors"]["description"]).to  eq("Invalid username/email or password.")
      end
    end
  end

  describe "destroy" do
    context "Positive Case" do
      it "should change the auth token on valid sign out request" do
        active_user
        old_auth_token = active_user.auth_token
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(active_user.auth_token)

        delete "destroy", :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(true)
        expect(response_body["alert"]).to  eq("Signed Out: You have successfully signed out")

        # Checking if the Auth Token has changed
        active_user.reload
        request.env['HTTP_AUTHORIZATION'] = nil
        credentials = {login_handle: active_user.username, password: ConfigCenter::Defaults::PASSWORD}

        post "create", credentials, :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(true)
        expect(response_body["alert"]).to  eq("Signed Out: You have successfully signed out")
        expect(response_body["data"]["name"]).to  eq("Mohandas Gandhi")
        expect(response_body["data"]["auth_token"]).not_to  eq(old_auth_token)
      end
    end
    context "Negative Case" do
      it "should not change the auth token and should render error for invalid request" do
        active_user
        old_auth_token = active_user.auth_token

        delete "destroy", :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(false)
        expect(response_body["alert"]).to  eq("Permission Denied: You don't have permission to perform this action")
        expect(response_body["data"]["errors"]["name"]).to  eq("AuthenticationError")
        expect(response_body["data"]["errors"]["description"]).to  eq("Permission Denied: You don't have permission to perform this action")
      end
    end
  end


end