class Post < ApplicationRecord 
  include ForeignOffice::Broadcaster
  
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_views
  has_one :post_activity

  after_save :refresh_activity

  attr_accessor :load_comment

  delegate :last_activity_time, to: :post_activity

  def comment_changed
    refresh_activity
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

  def refresh_activity
    post_views.destroy_all
    PostActivity.refresh
  end

  def serialize
    self.attributes.merge \
      load_comment: self.load_comment
  end

end
