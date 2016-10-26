class PostsController::CreatePost
  def initialize(params)
    @params = params
    @user = User.find params[:user_id]
  end

  def call
    @post = Post.create(@params)
    @user.friends.each &:broadcast_change
    @post
  end
end