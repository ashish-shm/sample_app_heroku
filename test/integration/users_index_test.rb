require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
 
  def setup
    @admin= users(:example)
    @non_admin = users(:archer)
  end
    
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
    assert_select 'a[href=?]', user_path(user), text: user.name
    unless user == @admin
    assert_select 'a[href=?]', user_path(user), text: 'delete'
    end
    end
    assert_difference 'User.count', -1 do
    delete user_path(@non_admin)
    end
  end
    
    
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  # test "check redirect to root url if user is not activated" do
  #   log_in_as(@inactivated)
  #   get users_path
  #   assert_not is_logged_in?
  # end
end
