module ApplicationHelper
  def friends_not_invited(chatroom)
  	return false if chatroom.friendship.present?
    current_user.friends - chatroom.users
  end
end
