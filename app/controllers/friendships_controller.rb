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
    friendship = Friendship.new(initiator_id: @current_user.id)
    render_ajax locals: {friendship: friendship}
  end

  def create
    friendship_creator = FriendshipCreator.new(params.merge(initiator_id: @current_user.id))
    friendship_creator.create
    case friendship_creator.status
    when :success
      head :ok
    when :error
      render partial: 'new', locals: {friendship: friendship_creator.friendship}, status: :conflict
    end
  end

  def accept
    friendship_accepter = FriendshipAccepter.new(params)
    friendship_accepter.accept
    render partial: 'show', locals: {friendship: friendship_accepter.friendship}
  end

  def destroy
    FriendshipEnder.new(params).end_friendship
    head :ok
  end
end
