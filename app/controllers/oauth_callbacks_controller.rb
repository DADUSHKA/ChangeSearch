# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    set_user("Github")
  end

  def facebook
    # render json: request.env['omniauth.auth']
    set_user("Facebook")
  end

  private

  def set_user(provider)
    @user = User.find_for_oauth(request.env["omniauth.auth"])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path
    end
  end
end
