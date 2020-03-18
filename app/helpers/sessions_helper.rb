module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    #nilであればfalse,
    #そうでなければ、すなわちログインしていればtrueを返す
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  #redirect to remembered url
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  #remember the url
  def store_location
    #request.original_urlでリクエスト先が取得できる
    session[:forwarding_url] = request.original_url if request.get?
  end
end
