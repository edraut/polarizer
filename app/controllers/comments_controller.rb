class CommentsController < ApplicationController
  before_filter :get_comment, only: [:edit, :show, :show_wrapper] #, :update]
  # before_filter :authorize, only: [:edit, :update]

  def index
    render_ajax
  end

  def new
    @comment = Comment.new(comment_params)
    render_ajax
  end

  def create
    @comment = CreateComment.new(comment_params).call
    if @comment.errors.empty?
      head :ok
    else
      render partial: 'new', locals: {comment: @comment}, status: 409
    end
  end

  def show
    render_ajax
  end

  def show_wrapper
    render partial: 'show', locals: {comment: @comment}, layout: '/layouts/comments/show_wrapper'
  end

protected

  def get_comment
    @comment = Comment.find params[:id]
  end

  def comment_params
    these_params = params.require(:comment).permit!
    these_params[:user_id] = @current_user.id
    these_params
  end

end