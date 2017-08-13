class PostsController::CreatePost
  def initialize(params)
    @params = params
    @user = User.find params[:user_id]
  end

  def call
    create_post
    ping_friends
    @post
  end

  def create_post
    @post = Post.create(@params)
  end

  def ping_friends
    @user.friends.each do |friend|
      friend.load_posts = true
      friend.broadcast_change
    end
  end
end