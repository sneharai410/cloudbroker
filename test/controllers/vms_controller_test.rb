require "test_helper"

class VmsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vm = vms(:one)
  end

  test "should get index" do
    get vms_url
    assert_response :success
  end

  test "should get new" do
    get new_vm_url
    assert_response :success
  end

  test "should create vm" do
    assert_difference("Vm.count") do
      post vms_url, params: { vm: { bandwidth: @vm.bandwidth, datacenter_id: @vm.datacenter_id, mips: @vm.mips, ram: @vm.ram, storage: @vm.storage } }
    end

    assert_redirected_to vm_url(Vm.last)
  end

  test "should show vm" do
    get vm_url(@vm)
    assert_response :success
  end

  test "should get edit" do
    get edit_vm_url(@vm)
    assert_response :success
  end

  test "should update vm" do
    patch vm_url(@vm), params: { vm: { bandwidth: @vm.bandwidth, datacenter_id: @vm.datacenter_id, mips: @vm.mips, ram: @vm.ram, storage: @vm.storage } }
    assert_redirected_to vm_url(@vm)
  end

  test "should destroy vm" do
    assert_difference("Vm.count", -1) do
      delete vm_url(@vm)
    end

    assert_redirected_to vms_url
  end
end
