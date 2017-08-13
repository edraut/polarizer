module ApplicationHelper
  def friends_not_invited(chatroom)
    current_user.friends - chatroom.users
  end
end
