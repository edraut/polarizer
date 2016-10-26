class User < ApplicationRecord
  include ForeignOffice::Broadcaster

  has_many :posts, ->{order(created_at: :desc)}, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :chat_participants, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :group_chatrooms, through: :chat_participants, source: :chatroom

  after_destroy :remove_friendships

  validates :email, presence: true, uniqueness: true
  
  def friendships
    Friendship.where("initiator_id = :id OR responder_id = :id", id: id).where(accepted: true)
  end

  def friendship_ids
    friendships.map &:id
  end

  def friend_ids
    friendships.map{|f| f.other_id(self)}
  end

  def friendship_chatrooms
    Chatroom.where(friendship_id: friendship_ids)
  end

  def friends
    User.where(id: friend_ids)
  end

  def remove_friendships
    friendships.destroy_all
  end

  def friend_posts
    friends.map{|f| f.posts}.flatten.sort_by{|p| p.last_activity_time}.reverse
  end

  def new_posts
    friend_posts.select{|p| p.new_to(self)}
  end

  def new_post_count
    new_posts.length
  end

  def friendship_requests
    Friendship.where("responder_id = :id", id: id).where(accepted: false)
  end

  def friendship_request_count
    friendship_requests.length
  end

  def pending_friendships
    Friendship.where("initiator_id = :id", id: id).where(accepted: false)
  end

  def pending_friendship_count
    pending_friendships.length
  end

  def comments_on_my_posts
    posts.includes(:comments).map(&:comments).flatten
  end

  def new_comments
    comments_on_my_posts.select{|c| !c.author_viewed }
  end

  def new_comment_count
    new_comments.length
  end

  def serialize
    self.attributes.merge \
      new_post_count: self.new_post_count,
      new_comment_count: self.new_comment_count,
      friendship_request_count: self.friendship_request_count,
      pending_friendship_count: self.pending_friendship_count
  end
end
