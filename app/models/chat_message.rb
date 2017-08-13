class ChatMessage < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  delegate :handle, to: :user, prefix: true
end
