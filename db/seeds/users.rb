class Users
	def self.seed
		User.create(email: 'user@gmail.com', first_name: 'App', last_name: 'User', handle: 'appuser')
		User.create(email: 'other_user@gmail.com', first_name: 'Other', last_name: 'User', handle: 'otheruser')
	end
end