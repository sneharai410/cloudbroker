require "test_helper"

class CloudletsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cloudlet = cloudlets(:one)
  end

  test "should get index" do
    get cloudlets_url
    assert_response :success
  end

  test "should get new" do
    get new_cloudlet_url
    assert_response :success
  end

  test "should create cloudlet" do
    assert_difference("Cloudlet.count") do
      post cloudlets_url, params: { cloudlet: { file_size: @cloudlet.file_size, length: @cloudlet.length, output_size: @cloudlet.output_size, workload_type: @cloudlet.workload_type } }
    end

    assert_redirected_to cloudlet_url(Cloudlet.last)
  end

  test "should show cloudlet" do
    get cloudlet_url(@cloudlet)
    assert_response :success
  end

  test "should get edit" do
    get edit_cloudlet_url(@cloudlet)
    assert_response :success
  end

  test "should update cloudlet" do
    patch cloudlet_url(@cloudlet), params: { cloudlet: { file_size: @cloudlet.file_size, length: @cloudlet.length, output_size: @cloudlet.output_size, workload_type: @cloudlet.workload_type } }
    assert_redirected_to cloudlet_url(@cloudlet)
  end

  test "should destroy cloudlet" do
    assert_difference("Cloudlet.count", -1) do
      delete cloudlet_url(@cloudlet)
    end

    assert_redirected_to cloudlets_url
  end
end
