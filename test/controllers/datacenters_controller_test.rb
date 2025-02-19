require "test_helper"

class DatacentersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @datacenter = datacenters(:one)
  end

  test "should get index" do
    get datacenters_url
    assert_response :success
  end

  test "should get new" do
    get new_datacenter_url
    assert_response :success
  end

  test "should create datacenter" do
    assert_difference("Datacenter.count") do
      post datacenters_url, params: { datacenter: { autoscaling: @datacenter.autoscaling, bandwidth: @datacenter.bandwidth, bandwidth_policy: @datacenter.bandwidth_policy, bw_cost: @datacenter.bw_cost, cpu_cost: @datacenter.cpu_cost, idle_power: @datacenter.idle_power, latency: @datacenter.latency, name: @datacenter.name, num_hosts: @datacenter.num_hosts, pe_mips: @datacenter.pe_mips, power_model: @datacenter.power_model, power_usage: @datacenter.power_usage, ram: @datacenter.ram, ram_cost: @datacenter.ram_cost, scheduling_policy: @datacenter.scheduling_policy, storage: @datacenter.storage, storage_cost: @datacenter.storage_cost, storage_type: @datacenter.storage_type, topology: @datacenter.topology } }
    end

    assert_redirected_to datacenter_url(Datacenter.last)
  end

  test "should show datacenter" do
    get datacenter_url(@datacenter)
    assert_response :success
  end

  test "should get edit" do
    get edit_datacenter_url(@datacenter)
    assert_response :success
  end

  test "should update datacenter" do
    patch datacenter_url(@datacenter), params: { datacenter: { autoscaling: @datacenter.autoscaling, bandwidth: @datacenter.bandwidth, bandwidth_policy: @datacenter.bandwidth_policy, bw_cost: @datacenter.bw_cost, cpu_cost: @datacenter.cpu_cost, idle_power: @datacenter.idle_power, latency: @datacenter.latency, name: @datacenter.name, num_hosts: @datacenter.num_hosts, pe_mips: @datacenter.pe_mips, power_model: @datacenter.power_model, power_usage: @datacenter.power_usage, ram: @datacenter.ram, ram_cost: @datacenter.ram_cost, scheduling_policy: @datacenter.scheduling_policy, storage: @datacenter.storage, storage_cost: @datacenter.storage_cost, storage_type: @datacenter.storage_type, topology: @datacenter.topology } }
    assert_redirected_to datacenter_url(@datacenter)
  end

  test "should destroy datacenter" do
    assert_difference("Datacenter.count", -1) do
      delete datacenter_url(@datacenter)
    end

    assert_redirected_to datacenters_url
  end
end
