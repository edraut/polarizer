class Chatroom < ApplicationRecord
  include ForeignOffice::Broadcaster

  belongs_to :friendship, optional: true
  has_many :chat_participants, dependent: :destroy
  has_many :users, through: :chat_participants
  has_many :chat_messages, dependent: :destroy

  attr_accessor :friend_id, :load_messages, :load_chat_participant

  def serialize
    self.attributes.merge \
      load_messages: self.load_messages,
      load_chat_participant: self.load_chat_participant
  end

end
