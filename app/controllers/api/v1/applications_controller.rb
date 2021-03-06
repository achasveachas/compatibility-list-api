class Api::V1::ApplicationsController < ApplicationController
  before_action :authenticate_token!
  before_action :verify_admin!, only: [:update, :create, :destroy]

  def index
    @applications = Application.all
    render 'applications/applications.json.jbuilder', applications: @applications
  end

  def show
    @application = Application.find_by(id: params[:id])
    if @application
      render 'applications/application.json.jbuilder', application: @application
    else
      render json: {
        errors: {
          message: "Page not found"
        }
      }, status: 404
    end
  end

  def create

    @application = Application.new(application_params)
    @application.comments.build(body: params[:application][:notes], user: current_user)
    if @application.save
      render 'applications/application.json.jbuilder', application: @application
    else
      render json: {
        errors: @application.errors.full_messages
      }, status: 500
    end

  end

  def update
    @application = Application.find_by(id: params[:id])
    @application.comments.build(body: params[:application][:notes], user: current_user) if params[:application][:notes]
    @application.update_attributes(application_params)
    if @application.save
      render 'applications/application.json.jbuilder', application: @application
    else
      render json: {
        errors: @application.errors.full_messages
      }, status: 500
    end
  end

  def destroy
    application = Application.find_by(id: params[:id])
    if application
      application.destroy
      head :no_content
    else
      render json: {
        errors: {
          message: "Page not found"
        }
      }, status: 404
    end
  end

  private

  def application_params
    params.require(:application).permit(:software, :gateway, :compatible, :omaha, :nashville, :north, :buypass, :elavon, :tsys, :other, :source, :agent, :ticket, :merchants_using)
  end

end
