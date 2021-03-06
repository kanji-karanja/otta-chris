require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup 
    @user = users(:chris)
  end

  test "micropost interrface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # Valid submission
    content = "Never send me blank again!"
    picture = fixture_file_upload('test/fixtures/rails-logo.svg', 'image/svg')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }
    end
    # use assigns method to access the micropost in the create action after valid submission
    micropost = assigns(:micropost)
    assert micropost.picture? 
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit different user (no delete links)
    get user_path(users(:ben))
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero microposts
    # other_user = users(:sumbua)
    # log_in_as(other_user)
    # get root_path
    # assert_match "0 microposts", response.body
    # other_user.microposts.create!(content: "Yeah, hurray!!")
    # get root_path
    # assert_match "#{other_user.microposts.count} micropost",  response.body
  end
end
