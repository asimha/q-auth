require "rails_helper"

RSpec.describe Api::V1::MyProfileController, :type => :controller do

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

  let!(:token) { ActionController::HttpAuthentication::Token.encode_credentials(active_user.auth_token) }

  describe "my_profile" do
    describe "Positive Case" do
      it "should return the user information with the for a valid auth token" do
        active_user
        request.env['HTTP_AUTHORIZATION'] = token

        get "my_profile", :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(true)
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

    describe "Negative Case" do
      it "should return the error the for no auth token" do
        get "my_profile", :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(false)
        expect(response_body["alert"]).to  eq("Permission Denied: You don't have permission to perform this action")
        expect(response_body["data"]["errors"]["name"]).to  eq("AuthenticationError")
        expect(response_body["data"]["errors"]["description"]).to  eq("Permission Denied: You don't have permission to perform this action")
      end

      it "should return the error the for a invalid auth token" do
        token = ActionController::HttpAuthentication::Token.encode_credentials("invalid token")
        request.env['HTTP_AUTHORIZATION'] = token

        get "my_profile", :format =>:json
        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(false)
        expect(response_body["alert"]).to  eq("Permission Denied: You don't have permission to perform this action")
        expect(response_body["data"]["errors"]["name"]).to  eq("AuthenticationError")
        expect(response_body["data"]["errors"]["description"]).to  eq("Permission Denied: You don't have permission to perform this action")
      end
    end
  end

  describe "update_profile" do
    let!(:department) {FactoryGirl.create(:department, name: "Indian Politics")}
    let!(:designation) {FactoryGirl.create(:designation, title: "National Leader")}
    let!(:biography) {"Mohandas Karamchand Gandhi was the preeminent leader of Indian nationalism in British-ruled India. Employing nonviolent civil disobedience, Gandhi led India to independence and inspired movements for civil rights and freedom across the world."}
    let!(:valid_user_information) { {user: {  name: "Mohandas Karam Chand Gandhi",
                                            username: "mohandas1234",
                                            email: "mohandas1234@gandhi.com",
                                            phone: "1234512345",
                                            skype: "mohandas_skype_12345",
                                            linkedin: "mohandas_linkedin",
                                            city: "Calicut",
                                            state: "Kerala",
                                            country: "Bharath",
                                            department: department.name,
                                            designation: designation.title,
                                            designation_overridden: "Leader of Opposition, Govt. India",
                                            linkedin: "mohandas_linkedin_12345",
                                            biography: biography}}}

    describe "Positive Case" do
      it "should update the user information with the data sent for valid auth token" do

        active_user
        request.env['HTTP_AUTHORIZATION'] = token

        put "update", valid_user_information, :format =>:json

        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(true)
        expect(response_body["data"]["name"]).to  eq("Mohandas Karam Chand Gandhi")
        expect(response_body["data"]["username"]).to  eq("mohandas1234")
        expect(response_body["data"]["email"]).to  eq("mohandas@gandhi.com")
        expect(response_body["data"]["phone"]).to  eq("1234512345")
        expect(response_body["data"]["skype"]).to  eq("mohandas_skype_12345")
        expect(response_body["data"]["linkedin"]).to  eq("mohandas_linkedin_12345")
        expect(response_body["data"]["city"]).to  eq("Calicut")
        expect(response_body["data"]["state"]).to  eq("Kerala")
        expect(response_body["data"]["country"]).to  eq("Bharath")
        expect(response_body["data"]["designation_overridden"]).to  eq("Leader of Opposition, Govt. India")
        expect(response_body["data"]["user_type"]).to  eq("user")
        expect(response_body["data"]["biography"]).to  eq(biography)
        expect(response_body["data"]["auth_token"]).to  eq(active_user.auth_token)
        expect(response_body["data"]["password"]).to  eq(nil)
        expect(response_body["data"]["password_digest"]).to  eq(nil)

        expect(response_body["data"]["designation"]["title"]).to  eq("National Leader")
        expect(response_body["data"]["department"]["name"]).to  eq("Indian Politics")
      end
    end

    describe "Negative Case" do

      it "should return error without token" do
        active_user

        put "update", valid_user_information, :format =>:json

        response_body = JSON.parse(response.body)
        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(false)
        expect(response_body["alert"]).to  eq("Permission Denied: You don't have permission to perform this action")
        expect(response_body["data"]["errors"]["name"]).to  eq("AuthenticationError")
        expect(response_body["data"]["errors"]["description"]).to  eq("Permission Denied: You don't have permission to perform this action")
      end

      it "should return error for invalid token" do
        active_user
        request.env['HTTP_AUTHORIZATION'] = "invalid token"

        put "update", valid_user_information, :format =>:json

        response_body = JSON.parse(response.body)
        expect(response.status).to  eq(200)
        expect(response_body["success"]).to  eq(false)
        expect(response_body["alert"]).to  eq("Permission Denied: You don't have permission to perform this action")
        expect(response_body["data"]["errors"]["name"]).to  eq("AuthenticationError")
        expect(response_body["data"]["errors"]["description"]).to  eq("Permission Denied: You don't have permission to perform this action")
      end

      it "should return error for invalid name" do
        active_user
        request.env['HTTP_AUTHORIZATION'] = token
        invalid_info = valid_user_information.dup
        invalid_info[:user][:name] = nil

        put "update", invalid_info, :format =>:json

        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body.keys).to  eq(["success", "alert", "data"])
        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to eq("Sorry, there are errors with the information you provided. Please review the data you have entered.")
        expect(response_body["data"]["errors"]["name"]).to  eq("ValidationError")
        expect(response_body["data"]["errors"]["description"]).to  eq("Sorry, there are errors with the information you provided. Please review the data you have entered.")
        expect(response_body["data"]["errors"]["details"]).to  eq({"name"=>["can't be blank", "is too short (minimum is 3 characters)"]})
      end

      it "should return error for invalid password" do
        active_user
        request.env['HTTP_AUTHORIZATION'] = token
        invalid_info = valid_user_information.dup
        invalid_info[:user][:password] = "invalid password"

        put "update", invalid_info, :format =>:json

        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body.keys).to  eq(["success", "alert", "data"])
        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to eq("Sorry, there are errors with the information you provided. Please review the data you have entered.")
        expect(response_body["data"]["errors"]["name"]).to  eq("ValidationError")
        expect(response_body["data"]["errors"]["description"]).to  eq("Sorry, there are errors with the information you provided. Please review the data you have entered.")
        expect(response_body["data"]["errors"]["details"]).to  eq({"password"=>["is invalid"]})
      end

      it "should return error for invalid password confirmation" do
        active_user
        request.env['HTTP_AUTHORIZATION'] = token
        invalid_info = valid_user_information.dup
        invalid_info[:user][:password] = "password 1"
        invalid_info[:user][:password_confirmation] = "password 2"

        put "update", invalid_info, :format =>:json

        response_body = JSON.parse(response.body)

        expect(response.status).to  eq(200)
        expect(response_body.keys).to  eq(["success", "alert", "data"])
        expect(response_body["success"]).to eq(false)
        expect(response_body["alert"]).to eq("Sorry, there are errors with the information you provided. Please review the data you have entered.")
        expect(response_body["data"]["errors"]["name"]).to  eq("ValidationError")
        expect(response_body["data"]["errors"]["description"]).to  eq("Sorry, there are errors with the information you provided. Please review the data you have entered.")
        expect(response_body["data"]["errors"]["details"]["password"]).to  eq(["is invalid"])
        expect(response_body["data"]["errors"]["details"]["password_confirmation"]).to  eq(["doesn't match Password"])
      end
    end
  end

end