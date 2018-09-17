class UsersController < ApplicationController
  def new
    @user = User.new
    render json: {hooch_modal: true, html: render_to_string(partial: 'new', layout: '/layouts/users/new_wrapper')}
  end

  def create
    @user = User.create(user_params)
    if @user.errors.empty?
      attach_session
      render json: {class_triggers: {"hooch.ReloadPage" => dashboard_path}}
    else
      render partial: 'new', status: :conflict
    end
  end

  def login
    @user = User.new
    render json: {hooch_modal: true, html: render_to_string(partial: 'login', layout: '/layouts/users/login_wrapper')}
  end

  def do_login
    @user = User.find_by email: user_params[:email]
    if @user
      attach_session
      render json: {class_triggers: {"hooch.ReloadPage" => dashboard_path}}
    else
      @user = User.new
      @user.errors.add(:email, 'Email is required to login.')
      render partial: 'login', status: :conflict
    end
  end

  def logout
    reset_session
    redirect_to root_path
  end

  def destroy
    @current_user.destroy
    redirect_to root_path
  end

  protected

  def user_params
    params.require(:user).permit!
  end

  def attach_session
    session[:user_id] = @user.id
  end
end
