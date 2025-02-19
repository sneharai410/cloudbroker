require "application_system_test_case"

class DatacentersTest < ApplicationSystemTestCase
  setup do
    @datacenter = datacenters(:one)
  end

  test "visiting the index" do
    visit datacenters_url
    assert_selector "h1", text: "Datacenters"
  end

  test "should create datacenter" do
    visit datacenters_url
    click_on "New datacenter"

    check "Autoscaling" if @datacenter.autoscaling
    fill_in "Bandwidth", with: @datacenter.bandwidth
    fill_in "Bandwidth policy", with: @datacenter.bandwidth_policy
    fill_in "Bw cost", with: @datacenter.bw_cost
    fill_in "Cpu cost", with: @datacenter.cpu_cost
    fill_in "Idle power", with: @datacenter.idle_power
    fill_in "Latency", with: @datacenter.latency
    fill_in "Name", with: @datacenter.name
    fill_in "Num hosts", with: @datacenter.num_hosts
    fill_in "Pe mips", with: @datacenter.pe_mips
    fill_in "Power model", with: @datacenter.power_model
    fill_in "Power usage", with: @datacenter.power_usage
    fill_in "Ram", with: @datacenter.ram
    fill_in "Ram cost", with: @datacenter.ram_cost
    fill_in "Scheduling policy", with: @datacenter.scheduling_policy
    fill_in "Storage", with: @datacenter.storage
    fill_in "Storage cost", with: @datacenter.storage_cost
    fill_in "Storage type", with: @datacenter.storage_type
    fill_in "Topology", with: @datacenter.topology
    click_on "Create Datacenter"

    assert_text "Datacenter was successfully created"
    click_on "Back"
  end

  test "should update Datacenter" do
    visit datacenter_url(@datacenter)
    click_on "Edit this datacenter", match: :first

    check "Autoscaling" if @datacenter.autoscaling
    fill_in "Bandwidth", with: @datacenter.bandwidth
    fill_in "Bandwidth policy", with: @datacenter.bandwidth_policy
    fill_in "Bw cost", with: @datacenter.bw_cost
    fill_in "Cpu cost", with: @datacenter.cpu_cost
    fill_in "Idle power", with: @datacenter.idle_power
    fill_in "Latency", with: @datacenter.latency
    fill_in "Name", with: @datacenter.name
    fill_in "Num hosts", with: @datacenter.num_hosts
    fill_in "Pe mips", with: @datacenter.pe_mips
    fill_in "Power model", with: @datacenter.power_model
    fill_in "Power usage", with: @datacenter.power_usage
    fill_in "Ram", with: @datacenter.ram
    fill_in "Ram cost", with: @datacenter.ram_cost
    fill_in "Scheduling policy", with: @datacenter.scheduling_policy
    fill_in "Storage", with: @datacenter.storage
    fill_in "Storage cost", with: @datacenter.storage_cost
    fill_in "Storage type", with: @datacenter.storage_type
    fill_in "Topology", with: @datacenter.topology
    click_on "Update Datacenter"

    assert_text "Datacenter was successfully updated"
    click_on "Back"
  end

  test "should destroy Datacenter" do
    visit datacenter_url(@datacenter)
    click_on "Destroy this datacenter", match: :first

    assert_text "Datacenter was successfully destroyed"
  end
end
