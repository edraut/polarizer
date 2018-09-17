require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
	include ActionView::RecordIdentifier

	setup do
		login(user)
	end

	test "it renders the new form" do
		get new_post_path
		assert_response :success
		assert_select 'form[action="/posts"]' do
			assert_select 'input[name="post[title]"]'
		end
	end

	test "it creates a post" do
		post posts_path, params: {post: {title: 'Fresh Avocado', body: "mmmmmmmm"}}
		assert_response :success
		post = Post.order(id: :desc).first
		assert_select "div##{dom_id(post)}" do
			assert_select 'h2', 'Fresh Avocado'
			assert_select 'div', "mmmmmmmm"
		end
	end

	test "it renders a helpful error message when creation fails" do
		#TODO add test cases where when we add an error case to handle
	end

	test "it renders the index" do
		get posts_path
		assert_response :success
		assert_select 'div', 'From Friends'
		assert_select 'div', 'My Posts'
	end

	test "it renders my posts" do
		#prerequisite state for the test
		assert_equal true, (user.posts.length > 0)

		get my_posts_path
		assert_response :success
		assert_select 'div#my_posts_list' do
			user.posts.each do |post|
				assert_select "div##{dom_id(post)}"
			end
		end
	end

	test "it renders my friends' posts" do
		#prerequisite state for the test
		Friendship.create(initiator_id: user.id, responder_id: other_user.id, accepted: true)
		assert_equal true, (other_user.posts.length > 0)

		get friend_posts_path
		assert_response :success
		assert_select 'div#friend_posts_list' do
			other_user.posts.each do |post|
				assert_select "div##{dom_id(post)}"
			end
		end
	end

	test "it renders a post" do
		post = Post.joins(:comments).first
		assert_equal true, post.comments.any?

		get post_path(post.id)
		assert_response :success
		assert_select 'h2', post.title
		assert_select 'div', post.body

		#comment lists are only rendered from this controller action, so we must test them here.
		assert_select "div##{dom_id(post, :comments)}" do
			post.comments.each do |comment|
				assert_select "div##{dom_id(comment)}" do
					assert_select 'div', comment.body
				end
			end
		end
	end

	test "it renders the edit form" do
		post = Post.first
		get edit_post_path(post.id)
		assert_response :success
		assert_select "form[action=\"/posts/#{post.id}\"]" do
			assert_select 'input[name="post[title]"]'
		end
	end

	test "it updates a post" do
		post = Post.first
		new_title = post.title + '--edited'
		patch post_path(post.id), params: {post: {title: new_title}}
		assert_response :success
		assert_equal new_title, post.reload.title
		assert_select 'h2', new_title		
	end

	test "it renders a helpful error message when updating fails" do
		#TODO add test cases where when we add an error case to handle
	end

end
