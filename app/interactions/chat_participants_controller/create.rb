class ChatParticipantsController::Create
  include Rails.application.routes.url_helpers

  def initialize(params)
    @params = params
  end

  def call
    @chat_participant = ChatParticipant.create(@params)
    chatroom = @chat_participant.chatroom
    chatroom.load_chat_participant = show_wrapper_chat_participant_path(@chat_participant)
    chatroom.broadcast_change
    @chat_participant
  end
end