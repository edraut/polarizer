require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
	test "it renders the new form" do
		get signup_path
		assert_response :success
		@response.body = JSON.parse(@response.body, object_class: OpenStruct).html
		assert_select "form[action=\"/create_user\"]" do
			assert_select 'input[name="user[first_name]"]'
		end
	end

	test "it renders the login form" do
		get login_path
		assert_response :success
		@response.body = JSON.parse(@response.body, object_class: OpenStruct).html
		assert_select 'form[action="/do_login"]' do
			assert_select 'input[name="user[email]"]'
		end
	end

	test "it creates a user" do
		unique_email = 'f3g4gn9v9@gmail.com'
		post create_user_path, params: { user: {email: unique_email, first_name: 'Eric', last_name: 'Draut', handle: 'edraut' }}
		assert_response :success
		response = JSON.parse(@response.body, object_class: OpenStruct)
		assert_equal '/dashboard', response.class_triggers['hooch.ReloadPage']
		assert_not_nil User.find_by(email: unique_email)
	end

	test "it renders helpful error messages if create fails" do
		duplicate_email = user.email
		user_count = User.count
		post create_user_path, params: { user: {email: duplicate_email}}
		assert_response :conflict
		assert_select 'div.field_with_errors' do
			assert_select 'span', 'has already been taken'
		end
		assert_equal user_count, User.count
	end

	test "it logs a user in" do
		post do_login_path params: {user: {email: user.email}}
		assert_response :success
		assert_equal user.id, session[:user_id]
	end

	test "it renders helpful error messages if login fails" do
		post do_login_path params: {user: {email: ''}}
		assert_response :conflict
		assert_nil session[:user_id]
	end

	test "it logs a user out" do
		login(user)
		get logout_path params: {user: {email: 'user@gmail.com'}}
		assert_response :redirect
		assert_nil session[:user_id]
	end

	test "it removes a user" do
		login(user)
		user_id = user.id
		delete remove_user_path
		assert_response :redirect
		assert_nil User.find_by(id: user_id)
	end

end
