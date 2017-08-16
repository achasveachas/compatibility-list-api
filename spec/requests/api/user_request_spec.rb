require 'rails_helper'

RSpec.describe "API::V1::Users", type: :request do

  before(:each) do
    @user = create(:user)
    @admin = create(:user, username: "Admin User", admin: true)
    @token = Auth.create_token(@user.id)
    @admin_token = Auth.create_token(@admin.id)
    @token_headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer: #{@token}"
    }
    @admin_headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': "Bearer: #{@admin_token}"
    }
    @tokenless_headers = {
      'Content-Type': 'application/json',
    }
  end

  describe "POST /users" do

    describe "on success" do

      before(:each) do
        params = {
          user: {
            username: "testuser",
            password: "testtest",
            name: "testname"
          }
        }

        post "/api/v1/users",
          params: params.to_json,
          headers: @admin_headers

        @response = response

      end

      it "creates a user from the params" do
        expect(User.all.count).to eq(3)
      end

      it "returns the new user and a JWT token" do
        body = JSON.parse(@response.body)

        expect(@response.status).to eq(200)
        expect(body['token']).not_to eq(nil)
        expect(body['user']['id']).not_to eq(nil)
        expect(body['user']['username']).to eq("testuser")
        expect(body['user']['name']).to eq("Testname")
        expect(body['user']['password_digest']).to eq(nil)

      end
    end

    describe "on authentication error" do

      it "only an authenticated user can add a user" do
        params = {
          user: {
            username: "testuser",
            password: "testtest",
            name: "testname"
          }
        }

        post "/api/v1/users",
          params: params.to_json,
          headers: @tokenless_headers

        body = JSON.parse(response.body)

        expect(response.status).to eq(403)
        expect(body["errors"]).to eq([{"message" => "You must include a JWT token"}])
      end

      it "only an admin user can add a user" do
        params = {
          user: {
            username: "testuser",
            password: "testtest",
            name: "testname"
          }
        }

        post "/api/v1/users",
          params: params.to_json,
          headers: @token_headers

        body = JSON.parse(response.body)

        expect(response.status).to eq(403)
        expect(body["errors"]).to eq([{"message" => "You must be an admin to perform this task"}])
      end
    end

    describe "on validation error" do

      it "required a valid email and password" do
        params = {
          user: {
            username: "",
            password: ""
          }
        }

        post "/api/v1/users",
          params: params.to_json,
          headers: @admin_headers

        body = JSON.parse(response.body)

        expect(response.status).to eq(500)
        expect(body["errors"]).to eq([
          "Password can't be blank",
          'Password is too short (minimum is 8 characters)',
          "Username can't be blank"])
      end
    end
  end

  describe "GET /users/:id" do

    describe "on success" do

      it "returns a list of all users" do
        get "/api/v1/users/#{@user.id}",
          headers: @token_headers

        body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(body['user']['id']).to eq(@user.id)
        expect(body['user']['username']).to eq(@user.username)
        expect(body['user']['name']).to eq(@user.name)
        expect(body['user']['password_digest']).to eq(nil)

      end
    end

    describe "on failure" do
      it "returns a status of 404 with an error message" do

        get "/api/v1/users/5",
          headers: @token_headers

        body = JSON.parse(response.body)
        expect(response.status).to eq(404)
        expect(body["errors"]).to eq([{"message"=> "Page not found"}])

      end
    end
  end
end
