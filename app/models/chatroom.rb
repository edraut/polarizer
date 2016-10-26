class Chatroom < ApplicationRecord
  belongs_to :friendship
  has_many :chat_participants, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
end
