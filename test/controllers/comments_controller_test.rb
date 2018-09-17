require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
	include ActionView::RecordIdentifier

	setup do
		login(user)
	end

	test "it renders the new form" do
		get new_comment_path(comment: {post_id: ppost.id})
		assert_response :success
		assert_select 'form[action="/comments"]' do
			assert_select 'input[name="comment[post_id]"]'
			assert_select 'textarea[name="comment[body]"]'
		end
	end

	test "it creates a comment" do
		post comments_path, params: {comment: {post_id: ppost.id, body: 'This is a witty comment.'}}
		assert_response :success
		latest_comment = ppost.comments.order(id: :desc).first
		assert_equal 'This is a witty comment.', latest_comment.body
		assert_equal user, latest_comment.user
	end

	test "it renders a helpful error message when creation fails" do
		#TODO add test cases where when we add an error case to handle
	end

	test "it renders a comment with its wrapper" do
		comment = Comment.first
		get show_wrapper_comment_path(comment)
		assert_response :success
		assert_select "div##{dom_id(comment)}" do
			assert_select 'div', comment.body
		end
	end

end