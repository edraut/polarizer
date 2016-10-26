class Friendship < ApplicationRecord
  belongs_to :initiator, class_name: 'User'
  belongs_to :responder, class_name: 'User'
  has_one :chatroom, dependent: :destroy

  def other_id(user)
    return responder_id if user.id == initiator_id
    return initiator_id if user.id == responder_id
    return nil
  end

  def friend_for(user)
    User.find other_id(user)
  end

  def members
    [initiator,responder]
  end

  def accept!
    update accepted: true
  end
end
