class FriendshipsController::AcceptFriendship
  def initialize(friendship)
    @friendship = friendship
  end

  def call
    @friendship.accept!
    @friendship.members.each &:broadcast_change
    @friendship
  end
end