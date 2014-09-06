class AuthController < ApplicationController

  def index
    # get your api keys at https://www.linkedin.com/secure/developer
    client = LinkedIn::Client.new("75824xh59zsaoh", "sD8TYov1UgVoCJEP")
    request_token = client.request_token(:oauth_callback =>
                                             "http://#{request.host_with_port}/auth/callback")
    session[:rtoken] = request_token.token
    session[:rsecret] = request_token.secret

    redirect_to client.request_token.authorize_url

  end

  def callback
    client = LinkedIn::Client.new("75824xh59zsaoh", "sD8TYov1UgVoCJEP")
    if session[:atoken].nil?
      pin = params[:oauth_verifier]
      atoken, asecret = client.authorize_from_request(session[:rtoken], session[:rsecret], pin)
      session[:atoken] = atoken
      session[:asecret] = asecret
    else
      client.authorize_from_access(session[:atoken], session[:asecret])
    end
    @profile = client.profile
    @user = User.find_by_atoken(session[:atoken])
    if @user.blank?
      User.create(name: @profile[:first_name], atoken: session[:atoken])
    end
    session[:current_user] = @profile[:first_name]
    redirect_to "/"
    #@connections = client.connections
  end

  def signout
    session[:atoken] = nil
    session[:asecret] = nil
    session[:current_user] = nil
    redirect_to "/"
  end
end