class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  after_save :notify_post


  def notify_post
    post.comment_changed
  end

end
