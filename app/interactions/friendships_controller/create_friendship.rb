class FriendshipsController::CreateFriendship
  def initialize(params)
    @params = params
  end

  def call
    @friendship = Friendship.create(@params)
    @friendship.members.each &:broadcast_change
    @friendship
  end
end