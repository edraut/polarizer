require 'test_helper'

class ChatMessagesControllerTest < ActionDispatch::IntegrationTest
	include ActionView::RecordIdentifier

	setup do
		login(user)
	end

	test "it renders the index" do
		chatroom = Chatroom.find_by title: 'Guacamole'
		message = chatroom.chat_messages.create(message: 'Great with tortilla chips', user_id: other_user.id)
		get chat_messages_path, params: {chatroom_id: chatroom.id}
		assert_response :success
		assert_select "div##{dom_id(chatroom, :message_list)}" do
			assert_select "div##{dom_id(message)}" do
				assert_select 'div', message.user_handle
				assert_select 'div', message.message
			end
		end
		assert_select 'form[action="/chat_messages"]' do
			assert_select "input[name=\"chat_message[chatroom_id]\"][value=\"#{chatroom.id}\"]"
		end
	end

end
