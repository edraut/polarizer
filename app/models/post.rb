class Post < ApplicationRecord 
  include ForeignOffice::Broadcaster
  
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_views
  has_one :post_activity

  attr_accessor :load_comment

  def comment_changed
    # post_activity.refresh
  end

  def new_to(user)
    post_views.where(user_id: user.id).empty?
  end

  def mark_viewed_by(user)
    post_views.create(user_id: user.id)
  end

  def mark_comments_viewed
    comments.update_all(author_viewed: true)
  end

  def last_activity_time
    comments.maximum(:updated_at) || updated_at
  end

  def serialize
    self.attributes.merge \
      load_comment: self.load_comment
  end

end
