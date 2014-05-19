class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

skip_before_filter :verify_authenticity_token, :only => [:steamv2, :failure]

def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    auth = env["omniauth.auth"]

    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
      session["devise.twitter_uid"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def steamv2
    auth = env["omniauth.auth"]

    @user = User.find_for_steam_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Steam") if is_navigational_format?
    else
      session["devise.steam_uid"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitch
    auth = env["omniauth.auth"]

    @user = User.find_for_twitch_oauth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Twitch") if is_navigational_format?
    else
      session["devise.twitch_uid"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end
