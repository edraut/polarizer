class ChatroomsController::Create
  def initialize(params,current_user)
    @params = params.to_h.to_hash.symbolize_keys
    @current_user = current_user
    @friend_id = @params.delete :friend_id
  end

  def call
    build_chatroom
    set_friendship
    save_chatroom or return @chatroom
    add_members
    @chatroom
  end

  def build_chatroom
    @chatroom = Chatroom.new(@params)
  end

  def set_friendship
    if @friend_id
      @chatroom.friendship = @current_user.friendships.to_a.detect{|friendship| friendship.member_ids.include? @friend_id.to_i}
    end
  end

  def save_chatroom
    @chatroom.save
  end

  def add_members
    if @chatroom.friendship
      @chatroom.users << @chatroom.friendship.friend_for(@current_user)
    end
    @chatroom.users << @current_user
  end
end