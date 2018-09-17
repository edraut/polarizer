require 'test_helper'

class DashboardControllerTest < ActionDispatch::IntegrationTest
	test "it renders the dashboard" do
		login(user)
		get dashboard_path
		assert_response :success
		assert_select 'div[data-tab-group="dashboard_tab"]'
	end

	test "it renders the dashboard stats view" do
		login(user)
		get dashboard_stats_path
		assert_response :success
		assert_select 'h2', 'New Post Activity from Friends'		
	end
end
