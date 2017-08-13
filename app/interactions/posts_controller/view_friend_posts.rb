class PostsController::ViewFriendPosts
  def initialize(user)
    @user = user
  end

  def call
    posts = @user.friend_posts.take(10)
    posts.each {|p| p.mark_viewed_by(@user)}
    @user.broadcast_change
    posts
  end
end