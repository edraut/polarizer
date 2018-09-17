class Chatrooms
	def self.seed
		user = User.find_by email: 'user@gmail.com'
		other_user = User.find_by email: 'other_user@gmail.com'
		guacamole = Chatroom.create(title: 'Guacamole')
		guacamole.users = [user,other_user]
	end
end