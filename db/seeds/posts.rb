class Posts
	def self.seed
		user = User.find_by email: 'user@gmail.com'
		other_user = User.find_by email: 'other_user@gmail.com'
		shins = Post.create(title: 'Gone for Good', body: 'James Mercer builds up whole worlds out of seemingly non-sensical lyrics...', user_id: user.id)
		Post.create(title: 'Carbon Monoxide', body: 'Cake has caustic words for those spewing caustic fumes...', user_id: user.id)
		Post.create(title: 'The Perfect Me', body: 'Deerhoof creates truly unique music...', user_id: other_user.id)
		Post.create(title: 'Peace Piece', body: "Bill Evans brought us new musical ideas and inspiration...", user_id: other_user.id)
		shins.comments.create(user_id: other_user.id, body: 'Love this song.')
	end
end