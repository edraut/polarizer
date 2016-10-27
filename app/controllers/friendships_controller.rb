class FriendshipsController < ApplicationController
  def index
    @friendships = @current_user.friendships
    @friendship_requests = @current_user.friendship_requests
    @pending_friendships = @current_user.pending_friendships
    render_ajax
  end

  def friends
    @friendships = @current_user.friendships
    render_ajax
  end
  
  def friend_requests
    @friendship_requests = @current_user.friendship_requests    
    render_ajax
  end

  def pending_friends
    @pending_friendships = @current_user.pending_friendships
    render_ajax
  end

  def new
    @friendship = Friendship.new(initiator_id: @current_user.id)
    sleep 5
    render_ajax
  end

  def create
    @responder = User.find_by(email: params[:email])
    if @responder
      @friendship = CreateFriendship.new(initiator_id: @current_user.id, responder_id: @responder.id).call
      if @friendship.errors.empty?
        head :ok
      else
        render partial: 'new', status: 409
      end
    else
      @friendship = Friendship.new(initiator_id: @current_user.id)
      @friendship.errors.add(:base, "We couldn't find the user with the email #{params[:email]}")
      render partial: 'new', status: 409      
    end
  end

  def accept
    @friendship = Friendship.find(params[:id])
    AcceptFriendship.new(@friendship).call
    render partial: 'show', locals: {friendship: @friendship}
  end
end
