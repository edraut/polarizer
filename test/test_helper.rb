ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def login(some_user)
		post do_login_path params: {user: {email: some_user.email}}
  end

	def user
		User.find_by email: 'user@gmail.com'
	end

	def other_user
		User.find_by email: 'other_user@gmail.com'
	end

	def ppost
		Post.find_by title: 'Carbon Monoxide'
	end
end

puts "cleaning database..."
previous_stdout, $stdout = $stdout, StringIO.new
include ActiveRecord::Tasks
DatabaseTasks.drop_current
DatabaseTasks.create_current
DatabaseTasks.load_schema_current
load "#{Rails.root}/db/seeds.rb"
$stdout = previous_stdout
puts "database clean, proceeding."