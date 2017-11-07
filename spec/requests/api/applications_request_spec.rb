require 'rails_helper'

RSpec.describe "API::V1::Applications", type: :request do

  describe "authentication" do

    before(:each) do
      @user = create(:user, admin: true)
      @application = @user.applications.new(software: "CardKnox")
      @application.comments.build(body: "Comment", user: @user)
      @application.save
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

      post "/api/v1/applications", headers: @tokenless_headers
      responses << response
      response_bodies << JSON.parse(response.body)


      patch "/api/v1/applications/#{@application.id}", headers: @tokenless_headers
      responses << response
      response_bodies << JSON.parse(response.body)

      responses.each {|r| expect(r).to have_http_status(403)}
      response_bodies.each {|body| expect(body["errors"]).to eq([{"message" => "You must include a JWT token"}])}
    end

  end

  describe "routes" do

    before(:each) do
      @user = create(:user, admin: true)
      3.times do |i|
        app = @user.applications.new(software: "Software number #{i + 1}")
        app.comments.build(body: "comment", user: @user)
        app.save
      end
      @application = @user.applications.first
      @token = Auth.create_token(@user.id)
      @token_headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': "Bearer: #{@token}"
      }
      @non_admin_user = create(:user, username: Faker::Internet.user_name, admin: false)
      @non_admin_token = Auth.create_token(@non_admin_user.id)
      @non_admin_token_headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': "Bearer: #{@non_admin_token}"
      }
    end

    describe "GET /api/v1/applications" do

      it "returns an array of applications" do

        get "/api/v1/applications",
          headers: @token_headers

        body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(body['applications']).to be_an(Array)
        expect(body['applications'].size).to eq(3)
      end

      it "returns applications belonging to all users" do
        user2 = User.create(username: "user2", password: "password2")
        application2 = user2.applications.new(software: "Wrong Company")
        application2.comments.build(body: "Body", user: user2)
        application2.save

        get "/api/v1/applications",
          headers: @token_headers

        body = JSON.parse(response.body)
        expect(body['applications'].size).to eq(4)
      end
    end

    describe "GET /api/v1/applications/:id" do

      describe "on success" do

        it "returns on application based on its id along with its comments" do

          get "/api/v1/applications/#{@application.id}",
            headers: @token_headers

          body = JSON.parse(response.body)

          expect(response.status).to eq(200)
          expect(body['application']).not_to eq(nil)
          expect(body['application']['id']).to eq(@application.id)
          expect(body['application']['comments']).to be_an(Array)
        end

      end

      describe "on failure" do
        it "returns a status of 404 with an error message" do

          get "/api/v1/applications/fakeid",
            headers: @token_headers

          body = JSON.parse(response.body)

          expect(response.status).to eq(404)
          expect(body["errors"]).to eq({"message"=> "Page not found"})

        end
      end
    end

    describe "POST /api/v1/applications" do
      params = {
        application: {
          software: 'Cardknox',
          notes: "Comment body"
        }
      }

      describe "on success" do

        before(:each) do
          post "/api/v1/applications",
            params: params.to_json,
            headers: @token_headers

          @body = JSON.parse(response.body)
        end

        it "creates a new instance of an Application" do
          application = Application.last
          expect(application.software).to eq(params[:application][:software])
        end

        it "returns the new Application with its comment" do
          application = Application.last

          expect(@body['application']['id']).to eq(application.id)
          expect(@body['application']['software']).to eq(application.software)
          expect(@body['application']['comments']).to be_an(Array)
          expect(@body['application']['comments'][0]["id"]).to eq(application.comments.first.id)
        end
      end

      describe "on failure" do

        it "doesn't let a non-admin user create an application" do
          post "/api/v1/applications",
            params: params.to_json,
            headers: @non_admin_token_headers

          body = JSON.parse(response.body)

          expect(response.status).to eq(403)
          expect(body["errors"]).to eq([{"message" => "You must be an admin to perform this task"}])
        end
      end
    end

    describe "PATCH /api/v1/applications" do
      params = {
        application: {
          software: 'USAePay',
          notes: "Another comment body"
        }
      }
      describe "on success" do
        before(:each) do
          patch "/api/v1/applications/#{Application.last.id}",
            params: params.to_json,
            headers: @token_headers

          @body = JSON.parse(response.body)
          @application = Application.last
        end

        it "updates the application" do
          expect(@application.software).to eq(params[:application][:software])
        end

        it "adds the note as a new comment" do
          expect(@application.comments.last.body).to eq(params[:application][:notes])
        end

        it "returns the updated Application with all comments" do

          expect(@body['application']['id']).to eq(@application.id)
          expect(@body['application']['software']).to eq(@application.software)
          expect(@body['application']['comments'][0]["id"]).to eq(@application.comments.first.id)
          expect(@body['application']['comments'][1]["id"]).to eq(@application.comments.last.id)
        end
      end

      describe "on failure" do
        it "doesn't let a non-admin user update an application" do
          patch "/api/v1/applications/#{Application.last.id}",
            params: params.to_json,
            headers: @non_admin_token_headers

          body = JSON.parse(response.body)

          expect(response.status).to eq(403)
          expect(body["errors"]).to eq([{"message" => "You must be an admin to perform this task"}])
        end
      end
    end

    describe "DELETE /api/v1/applications/:id" do

      describe "on success" do

        it "deletes the application and returns a status of 204" do
          delete "/api/v1/applications/#{@application.id}",
            headers: @token_headers


          expect(Application.find_by(id: @application.id)).to eq(nil)
          expect(response.status).to eq(204)

        end

      end

      describe "on failure" do
        it "returns a status of 404 with an error message" do

          delete "/api/v1/applications/fakeid",
            headers: @token_headers


          body = JSON.parse(response.body)
          expect(response.status).to eq(404)
          expect(body["errors"]).to eq({"message"=> "Page not found"})

        end

        it "doesn't let a non-admin user delete an application" do
          delete "/api/v1/applications/#{Application.last.id}",
            headers: @non_admin_token_headers

          body = JSON.parse(response.body)

          expect(response.status).to eq(403)
          expect(body["errors"]).to eq([{"message" => "You must be an admin to perform this task"}])
        end
      end
    end
  end

end
