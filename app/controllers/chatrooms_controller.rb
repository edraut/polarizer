class ChatroomsController < ApplicationController
  before_action :get_chatroom, only: [:edit, :show, :update]
  before_action :authorize, only: [:edit, :update]

  def index
    @chatrooms = current_user.group_chatrooms
    render_ajax
  end

  def list
    render_ajax locals: {chatrooms: current_user.group_chatrooms}
  end

  def new
    @chatroom = Chatroom.new(chatroom_params)
    render_ajax
  end

  def create
    @chatroom = Create.new(chatroom_params,current_user).call
    if @chatroom.errors.empty?
      render partial: 'show', locals: {chatroom: @chatroom, scroll_pointer: 0}, layout: 'chatrooms/show_wrapper'
    else
      render partial: 'new', locals: {chatroom: @chatroom}, status: 409
    end
  end

  protected

  def chatroom_params
    params.require(:chatroom).permit!
  end

  def get_chatroom
    @chatroom = Chatroom.find(params[:id])
  end

  def authorize
    render nothing: true, status: 409 unless @chatroom.users.include?(@current_user)
  end
end
