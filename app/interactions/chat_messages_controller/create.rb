class ChatMessagesController::Create

  def initialize(params)
    @params = params
    @chatroom = Chatroom.find params[:chatroom_id]
  end

  def call
    @chat_message = @chatroom.chat_messages.create(@params)
    @chatroom.load_messages = true
    @chatroom.broadcast_change
    @chat_message
  end
end