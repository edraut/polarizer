class FriendshipsController::CreateFriendship
  def initialize(params)
    @params = params
  end

  def call
    @friendship = Friendship.create(@params)
    @friendship.initiator.load_pending_friends = true
    @friendship.initiator.broadcast_change
    @friendship.responder.load_friend_requests = true
    @friendship.responder.broadcast_change
    @friendship
  end
end