class ChatMessagesController < ApplicationController
  before_action :get_chat_message, only: [:edit, :show, :show_wrapper] #, :update]
  # before_action :authorize, only: [:edit, :update]

  def index
    @chatroom = Chatroom.find(params[:chatroom_id])
    render_ajax locals: {chatroom: @chatroom, scroll_pointer: params[:scroll_pointer] || 0}
  end

  def list
    @chatroom = Chatroom.find(params[:chatroom_id])
    render_ajax locals: {chatroom: @chatroom, scroll_pointer: params[:scroll_pointer] || 0}
  end

  def new
    @chat_message = ChatMessage.new(chat_message_params)
    render_ajax locals: {chat_message: @chat_message}
  end

  def create
    @chat_message = Create.new(chat_message_params).call
    if @chat_message.errors.empty?
      @new_chat_message = ChatMessage.new(chatroom_id: @chat_message.chatroom_id)
      render partial: 'new', locals: {chat_message: @new_chat_message}
    else
      render partial: 'new', locals: {chat_message: @chat_message}, status: 409
    end
  end

  def show
    render_ajax
  end

  def show_wrapper
    render partial: 'show', locals: {chat_message: @chat_message}, layout: '/layouts/chat_messages/show_wrapper'
  end

protected

  def get_chat_message
    @chat_message = ChatMessage.find params[:id]
  end

  def chat_message_params
    these_params = params.require(:chat_message).permit!
    these_params[:user_id] = @current_user.id
    these_params
  end

end