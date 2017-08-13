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

  def show
    render_ajax locals: {chatroom: @chatroom}
  end

  def edit
    render_ajax locals: {chatroom: @chatroom}
  end

  def update
    @chatroom.update_attributes(chatroom_params)
    if @chatroom.errors.empty?
      render partial: 'show', locals: {chatroom: @chatroom}
    else
      render partial: 'edit', locals: {chatroom: @chatroom}, status: 409
    end
  end

  def show_wrapper
    render partial: 'show', locals: {chatroom: @chatroom}, layout: '/layouts/chatrooms/show_wrapper'
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
