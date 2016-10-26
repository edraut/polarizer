class CommentsController::CreateComment
  include Rails.application.routes.url_helpers

  def initialize(params)
    @params = params
    @post = Post.find params[:post_id]
  end

  def call
    @comment = Comment.create(@params)
    @post.load_comment = show_wrapper_comment_path(@comment)
    @post.broadcast_change
    @comment
  end
end