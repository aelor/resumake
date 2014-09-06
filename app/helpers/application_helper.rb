module ApplicationHelper

  def current_user
    User.find_by_atoken(session[:atoken])
  end
end
