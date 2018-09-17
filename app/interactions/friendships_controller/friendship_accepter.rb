class FriendshipsController::FriendshipAccepter

  attr_accessor :friendship
  
  def initialize(params)
    @friendship = Friendship.find(params[:id])
  end

  def accept
    persist_acceptance
    broadcast_state
  end

  def persist_acceptance
    @friendship.update accepted: true
  end

  def broadcast_state
    @friendship.members.each do |user|
      user.load_posts = true
      user.load_pending_friends = true
      user.load_friend_requests = true
      user.load_friends = true
      user.broadcast_change
    end
  end
end