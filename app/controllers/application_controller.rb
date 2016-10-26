class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :handle_user_session

  protected

  def handle_user_session
    @current_user = User.find_by(id: session[:user_id])
  end

  def logged_in?
    @current_user.present?
  end
end
