class DashboardController < ApplicationController
  before_filter :authenticate
  def show
  end

  def stats
    render_ajax
  end
  
  protected

  def authenticate
    redirect_to root_path unless logged_in?
  end
end
