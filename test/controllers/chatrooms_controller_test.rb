require 'test_helper'

class ChatroomsControllerTest < ActionDispatch::IntegrationTest
	include ActionView::RecordIdentifier

	setup do
		login(user)
	end

	test "it renders the new form" do
		get new_chatroom_path, params: {chatroom: {friendship_id: nil}}
		assert_response :success
		assert_select 'form[action="/chatrooms"]' do
			assert_select 'input[name="chatroom[title]"]'
		end
	end

	test "it creates a chatroom" do
		post chatrooms_path, params: {chatroom: {title: "Bokononism"}}
		assert_response :success
		chatroom = Chatroom.order(id: :desc).first
		assert_select "div##{dom_id(chatroom)}" do
			assert_select 'h2', chatroom.title
		end
	end

	test "it creates a one-on-one chatroom" do
		friendship = Friendship.create(initiator_id: user.id, responder_id: other_user.id, accepted: true)
		post chatrooms_path, params: {chatroom: {title: "Brioche Recipes", friend_id: other_user.id}}
		assert_response :success
		chatroom = Chatroom.order(id: :desc).first
		assert_equal friendship, chatroom.friendship
		assert_select "div##{dom_id(chatroom)}" do
			assert_select 'h2', chatroom.title
		end
	end

	test "it renders a helpful error message when creation fails" do
		#TODO add test cases where when we add an error case to handle
	end

	test "it renders the list" do
		get list_chatrooms_path
		assert_response :success
		assert_equal true, user.group_chatrooms.any?
		user.group_chatrooms.each do |chatroom|
			assert_select "div##{dom_id(chatroom)}" do
				assert_select 'h2', chatroom.title
			end
		end
	end

	test "it renders the index" do
		get chatrooms_path
		assert_response :success
		assert_equal true, user.group_chatrooms.any?
		user.group_chatrooms.each do |chatroom|
			assert_select "div##{dom_id(chatroom)}" do
				assert_select 'h2', chatroom.title
			end
		end
		assert_select 'a', 'Create a new chat room'
	end
end