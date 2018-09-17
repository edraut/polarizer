class FriendshipsController::FriendshipCreator

  attr_accessor :status, :friendship

  def initialize(params)
    @params = params
    @status = :success #optimism!
  end

  def create
    build_friendship
    get_responder or return false
    persist_friendship or return false
    broadcast_state
  end

  def build_friendship
    @friendship = Friendship.new(initiator_id: @params[:initiator_id])
  end

  def get_responder
    @responder = User.find_by(email: @params[:email])
    if @responder.nil?
      @friendship.errors.add(:base, "We couldn't find the user with the email #{@params[:email]}")
      @status = :error
      return false
    end
    return true
  end

  def persist_friendship
    @friendship.responder_id = @responder.id
    if @friendship.save
      return true
    else
      @status = :error
      return false
    end
  end

  def broadcast_state
    @friendship.initiator.load_pending_friends = true
    @friendship.initiator.broadcast_change
    @friendship.responder.load_friend_requests = true
    @friendship.responder.broadcast_change
  end

end