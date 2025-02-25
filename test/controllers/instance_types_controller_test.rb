require "test_helper"

class InstanceTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get instance_types_index_url
    assert_response :success
  end

  test "should get show" do
    get instance_types_show_url
    assert_response :success
  end

  test "should get new" do
    get instance_types_new_url
    assert_response :success
  end

  test "should get edit" do
    get instance_types_edit_url
    assert_response :success
  end
end
