require "application_system_test_case"

class HostsTest < ApplicationSystemTestCase
  setup do
    @host = hosts(:one)
  end

  test "visiting the index" do
    visit hosts_url
    assert_selector "h1", text: "Hosts"
  end

  test "should create host" do
    visit hosts_url
    click_on "New host"

    fill_in "Bandwidth", with: @host.bandwidth
    fill_in "Datacenter", with: @host.datacenter_id
    fill_in "Pe count", with: @host.pe_count
    fill_in "Ram", with: @host.ram
    fill_in "Storage", with: @host.storage
    click_on "Create Host"

    assert_text "Host was successfully created"
    click_on "Back"
  end

  test "should update Host" do
    visit host_url(@host)
    click_on "Edit this host", match: :first

    fill_in "Bandwidth", with: @host.bandwidth
    fill_in "Datacenter", with: @host.datacenter_id
    fill_in "Pe count", with: @host.pe_count
    fill_in "Ram", with: @host.ram
    fill_in "Storage", with: @host.storage
    click_on "Update Host"

    assert_text "Host was successfully updated"
    click_on "Back"
  end

  test "should destroy Host" do
    visit host_url(@host)
    click_on "Destroy this host", match: :first

    assert_text "Host was successfully destroyed"
  end
end
