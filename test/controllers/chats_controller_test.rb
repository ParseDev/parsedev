require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get chats_new_url
    assert_response :success
  end
end
