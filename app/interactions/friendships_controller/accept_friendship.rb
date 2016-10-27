class FriendshipsController::AcceptFriendship
  def initialize(friendship)
    @friendship = friendship
  end

  def call
    @friendship.accept!
    @friendship.members.each do |user|
      user.load_posts = true
      user.load_pending_friends = true
      user.load_friend_requests = true
      user.load_friends = true
      user.broadcast_change
    end
    @friendship
  end
end