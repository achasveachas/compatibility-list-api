require 'rails_helper'

RSpec.describe "API::V1::Applications", type: :request do

  describe "authentication" do

    before(:each) do
      @user = create(:user)
      @application = @user.applications.create(software: "CardKnox")
      @token = Auth.create_token(@user.id)
      @token_headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': "Bearer: #{@token}"
      }
      @tokenless_headers = {
        'Content-Type': 'application/json',
      }
    end

    it "requires a token to make and edit an application" do
      responses = []
      response_bodies = []

      post "/api/v1/users/#{@user.id}/applications", headers: @tokenless_headers
      responses << response
      response_bodies << JSON.parse(response.body)


      patch "/api/v1/users/#{@user.id}/applications/#{@application.id}", headers: @tokenless_headers
      responses << response
      response_bodies << JSON.parse(response.body)

      responses.each {|r| expect(r).to have_http_status(403)}
      response_bodies.each {|body| expect(body["errors"]).to eq([{"message" => "You must include a JWT token"}])}
    end

  end

  describe "routes" do

    before(:each) do
      @user = create(:user)
      3.times do |i|
        @user.applications.create(software: "Software number #{i + 1}")
      end
      @application = @user.applications.first
      @token = Auth.create_token(@user.id)
      @token_headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': "Bearer: #{@token}"
      }
    end

    describe "GET /api/v1/users/:id/applications" do

      it "returns an array of applications belonging to a given user" do

        get "/api/v1/users/#{@user.id}/applications"

        body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(body['applications']).to be_an(Array)
        expect(body['applications'].size).to eq(3)
      end

      it "doesn't return applications belonging to other users" do
        user2 = User.create(username: "user2", password: "password2")
        application2 = user2.applications.create(software: "Wrong Company")

        get "/api/v1/users/#{@user.id}/applications"
        body = JSON.parse(response.body)
        expect(body['applications'].last['user_id']).not_to eq(user2.id)
      end
    end

    describe "GET /api/v1.users/:user_id/applications/:id" do

      describe "on success" do

        it "returns on application based on its id" do

          get "/api/v1/users/#{@user.id}/applications/#{@application.id}"

          body = JSON.parse(response.body)

          expect(response.status).to eq(200)
          expect(body['application']).not_to eq(nil)
          expect(body['application']['id']).to eq(@application.id)
        end

      end

      describe "on failure" do
        it "returns a status of 404 with an error message" do

          get "/api/v1/users/#{@user.id}/applications/fakeid"

          body = JSON.parse(response.body)

          expect(response.status).to eq(404)
          expect(body["errors"]).to eq({"message"=> "Page not found"})

        end
      end
    end

    describe "POST /api/v1/users/:id/applications" do
      params = {
        application: {
          software: 'Cardknox'
        }
      }

      before(:each) do
        post "/api/v1/users/#{@user.id}/applications",
          params: params.to_json,
          headers: @token_headers

        @body = JSON.parse(response.body)
      end

      it "creates a new instance of an Application" do
        # binding.pry
        application = Application.last
        expect(application.software).to eq(params[:application][:software])
      end

      it "returns the new Application" do
        application = Application.last

        expect(@body['application']['id']).to eq(application.id)
        expect(@body['application']['software']).to eq(application.software)
      end
    end

    describe "PATCH /api/v1/users/:id/applications" do
      params = {
        application: {
          software: 'USAePay',
        }
      }

      before(:each) do
        patch "/api/v1/users/#{@user.id}/applications/#{@user.applications.last.id}",
          params: params.to_json,
          headers: @token_headers

        @body = JSON.parse(response.body)
      end

      it "updates the application" do
        application = Application.last
        expect(application.software).to eq(params[:application][:software])

      end

      it "returns the updated Application" do
        application = Application.last

        expect(@body['application']['id']).to eq(application.id)
        expect(@body['application']['software']).to eq(application.software)
      end
    end

    describe "DELETE /api/v1.users/:user_id/applications/:id" do

      describe "on success" do

        it "deletes the application and returns a status of 204" do
          delete "/api/v1/users/#{@user.id}/applications/#{@application.id}",
            headers: @token_headers


          expect(Application.find_by(id: @application.id)).to eq(nil)
          expect(response.status).to eq(204)

        end

      end

      describe "on failure" do
        it "returns a status of 404 with an error message" do

          delete "/api/v1/users/#{@user.id}/applications/fakeid",
            headers: @token_headers


          body = JSON.parse(response.body)
          expect(response.status).to eq(404)
          expect(body["errors"]).to eq({"message"=> "Page not found"})

        end
      end
    end
  end

end
