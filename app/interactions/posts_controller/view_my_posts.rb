class PostsController::ViewMyPosts
  def initialize(user)
    @user = user
  end

  def call
    posts = @user.posts
    posts.each {|p| p.mark_comments_viewed}
    @user.broadcast_change
    posts
  end
end