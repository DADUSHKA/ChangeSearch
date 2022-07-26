# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.json { render json: exception.message, status: :forbidden }
      format.js { render json: exception.message, status: :forbidden }
    end
  end

  check_authorization unless: :devise_controller?
end
