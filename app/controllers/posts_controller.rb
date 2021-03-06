class PostsController < ApplicationController
  before_action :get_post, only: [:edit, :show, :update]
  before_action :authorize, only: [:edit, :update]

  def index
    render_ajax
  end

  def friend
    friend_posts = ViewFriendPosts.new(@current_user).call
    render_ajax locals: {friend_posts: friend_posts}
  end

  def my
    my_posts = ViewMyPosts.new(@current_user).call
    render_ajax locals: {my_posts: my_posts}
  end

  def new
    post = Post.new(user_id: @current_user)
    render_ajax locals: {post: post}
  end

  def create
    @post = CreatePost.new(post_params).call
    if @post.errors.empty?
      render partial: 'show', locals: {post: @post}, layout: 'posts/show_wrapper'
    else
      render partial: 'new', locals: {post: @post}, status: 409
    end
  end

  def show
    render_ajax locals: {post: @post}
  end

  def edit
    render_ajax locals: {post: @post}
  end

  def update
    @post.update_attributes(post_params)
    if @post.errors.empty?
      render partial: 'show', locals: {post: @post}
    else
      render partial: 'edit', locals: {post: @post}, status: 409
    end
  end

  protected

  def post_params
    these_params = params.require(:post).permit!
    these_params[:user_id] = @current_user.id
    these_params
  end

  def get_post
    @post = Post.find(params[:id])
  end

  def authorize
    render nothing: true, status: 409 unless @post.user_id = @current_user.id
  end
end
