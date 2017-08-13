class ChatParticipantsController < ApplicationController
  before_action :get_chat_participant, only: [:edit, :show, :show_wrapper] #, :update]
  # before_action :authorize, only: [:edit, :update]

  def index
    @chatroom = Chatroom.find(params[:chatroom_id])
    render_ajax locals: {chatroom: @chatroom}
  end

  def new
    @chat_participant = ChatParticipant.new(chat_participant_params)
    render_ajax locals: {chat_participant: @chat_participant}
  end

  def create
    @chat_participant = Create.new(chat_participant_params).call
    if @chat_participant.errors.empty?
      head :ok
    else
      render partial: 'new', locals: {chat_participant: @chat_participant}, status: 409
    end
  end

  def show
    render_ajax
  end

  def show_wrapper
    render partial: 'show', locals: {chat_participant: @chat_participant}, layout: '/layouts/chat_participants/show_wrapper'
  end

protected

  def get_chat_participant
    @chat_participant = ChatParticipant.find params[:id]
  end

  def chat_participant_params
    params.require(:chat_participant).permit!
  end

end