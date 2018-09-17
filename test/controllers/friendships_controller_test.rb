require 'test_helper'

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
	test "it renders the new form" do
		login(user)
		get new_friendship_path
		assert_response :success
		assert_select 'form[action="/friendships"]' do
			assert_select 'input[name="email"]'
		end
	end

	test "in creates a friendship" do
		last_friendship = Friendship.order(id: :desc).first
		login(user)
		post create_friendship_path params: {email: other_user.email}
		assert_response :success
		latest_friendship = Friendship.order(id: :desc).first
		assert_not_equal latest_friendship, last_friendship
		assert_equal user, latest_friendship.initiator
		assert_equal other_user, latest_friendship.responder
	end

	test "it renders a helpful error message for non existant email addresses" do
		last_friendship = Friendship.order(id: :desc).first
		login(user)
		post create_friendship_path params: {email: 'non_existant_email@gmail.com'}
		assert_response :conflict
		latest_friendship = Friendship.order(id: :desc).first
		assert_equal latest_friendship, last_friendship if last_friendship
		assert_select 'div.error', "We couldn't find the user with the email non_existant_email@gmail.com"
	end

	test "it renders a helpful error message for trying to friend oneself" do
		last_friendship = Friendship.order(id: :desc).first
		login(user)
		post create_friendship_path params: {email: user.email}
		assert_response :conflict
		latest_friendship = Friendship.order(id: :desc).first
		assert_equal latest_friendship, last_friendship if last_friendship
		assert_select 'div.error', "You can't friend yourself"
	end

	test "it renders the index" do
		Friendship.create(initiator_id: user.id, responder_id: other_user.id, accepted: true)
		login(user)
		get friendships_path
		assert_select 'div#friendships_list', Regexp.new("You are friends with #{other_user.email}")
	end

	test "it renders the friends sub-view" do
		Friendship.create(initiator_id: user.id, responder_id: other_user.id, accepted: true)
		login(user)
		get friends_path
		assert_match "You are friends with #{other_user.email}", @response.body
	end

	test "it accepts a friendship" do
		friendship = Friendship.create(initiator_id: user.id, responder_id: other_user.id)
		login(user)
		patch accept_friendship_path(id: friendship.id)
		assert_response :success
		assert_match "You are friends with #{other_user.email}", @response.body
		friendship = Friendship.find friendship.id
		assert_equal true, friendship.accepted?
	end

	test 'it ends a friendship' do
		friendship = Friendship.create(initiator_id: user.id, responder_id: other_user.id, accepted: true)		
		assert_equal true, friendship.persisted?
		login(user)
		delete end_friendship_path(friendship)
		assert_response :success
		assert_nil Friendship.find_by(id: friendship.id)
	end

	test 'it renders friend requests' do
		friendship = Friendship.create(initiator_id: other_user.id, responder_id: user.id)
		login(user)
		get friend_requests_path
		assert_response :success
		assert_select 'div', Regexp.new("#{other_user.email} is awaiting your response.")
	end

	test 'it renders pending friends' do
		friendship = Friendship.create(initiator_id: user.id, responder_id: other_user.id)
		login(user)
		get pending_friends_path
		assert_response :success
		assert_select 'div', Regexp.new("Awaiting response from #{other_user.email}")
	end
end
