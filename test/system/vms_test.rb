require "application_system_test_case"

class VmsTest < ApplicationSystemTestCase
  setup do
    @vm = vms(:one)
  end

  test "visiting the index" do
    visit vms_url
    assert_selector "h1", text: "Vms"
  end

  test "should create vm" do
    visit vms_url
    click_on "New vm"

    fill_in "Bandwidth", with: @vm.bandwidth
    fill_in "Datacenter", with: @vm.datacenter_id
    fill_in "Mips", with: @vm.mips
    fill_in "Ram", with: @vm.ram
    fill_in "Storage", with: @vm.storage
    click_on "Create Vm"

    assert_text "Vm was successfully created"
    click_on "Back"
  end

  test "should update Vm" do
    visit vm_url(@vm)
    click_on "Edit this vm", match: :first

    fill_in "Bandwidth", with: @vm.bandwidth
    fill_in "Datacenter", with: @vm.datacenter_id
    fill_in "Mips", with: @vm.mips
    fill_in "Ram", with: @vm.ram
    fill_in "Storage", with: @vm.storage
    click_on "Update Vm"

    assert_text "Vm was successfully updated"
    click_on "Back"
  end

  test "should destroy Vm" do
    visit vm_url(@vm)
    click_on "Destroy this vm", match: :first

    assert_text "Vm was successfully destroyed"
  end
end
