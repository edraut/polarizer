class FriendshipsController::FriendshipEnder

  def initialize(params)
    @friendship = Friendship.find(params[:id])
  end

  def end_friendship
    destroy_record
    broadcast_state
  end

  def destroy_record
    @friendship.destroy
  end

  def broadcast_state
    @friendship.members.each do |user|
      user.load_posts = true
      user.load_friends = true
      user.broadcast_change
    end
  end

end