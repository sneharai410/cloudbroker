require "test_helper"

class SimulationResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @simulation_result = simulation_results(:one)
  end

  test "should get index" do
    get simulation_results_url
    assert_response :success
  end

  test "should get new" do
    get new_simulation_result_url
    assert_response :success
  end

  test "should create simulation_result" do
    assert_difference("SimulationResult.count") do
      post simulation_results_url, params: { simulation_result: { bw_breach: @simulation_result.bw_breach, bw_utilization: @simulation_result.bw_utilization, cloudlet_file_size: @simulation_result.cloudlet_file_size, cloudlet_id: @simulation_result.cloudlet_id, cloudlet_length: @simulation_result.cloudlet_length, cloudlet_output_size: @simulation_result.cloudlet_output_size, cloudlet_pes: @simulation_result.cloudlet_pes, cost: @simulation_result.cost, cpu_breach: @simulation_result.cpu_breach, cpu_utilization: @simulation_result.cpu_utilization, datacenter_bw_cost: @simulation_result.datacenter_bw_cost, datacenter_cpu_cost: @simulation_result.datacenter_cpu_cost, datacenter_id: @simulation_result.datacenter_id, datacenter_ram_cost: @simulation_result.datacenter_ram_cost, datacenter_storage_cost: @simulation_result.datacenter_storage_cost, execution_time: @simulation_result.execution_time, execution_time_breach: @simulation_result.execution_time_breach, host_bw: @simulation_result.host_bw, host_cpu_cores: @simulation_result.host_cpu_cores, host_id: @simulation_result.host_id, host_mips: @simulation_result.host_mips, host_ram: @simulation_result.host_ram, host_storage: @simulation_result.host_storage, ram_breach: @simulation_result.ram_breach, ram_utilization: @simulation_result.ram_utilization, sla_breach: @simulation_result.sla_breach, sla_breach_cost: @simulation_result.sla_breach_cost, storage_utilization: @simulation_result.storage_utilization, vm_bw: @simulation_result.vm_bw, vm_cpu_cores: @simulation_result.vm_cpu_cores, vm_id: @simulation_result.vm_id, vm_mips: @simulation_result.vm_mips, vm_ram: @simulation_result.vm_ram, vm_storage: @simulation_result.vm_storage } }
    end

    assert_redirected_to simulation_result_url(SimulationResult.last)
  end

  test "should show simulation_result" do
    get simulation_result_url(@simulation_result)
    assert_response :success
  end

  test "should get edit" do
    get edit_simulation_result_url(@simulation_result)
    assert_response :success
  end

  test "should update simulation_result" do
    patch simulation_result_url(@simulation_result), params: { simulation_result: { bw_breach: @simulation_result.bw_breach, bw_utilization: @simulation_result.bw_utilization, cloudlet_file_size: @simulation_result.cloudlet_file_size, cloudlet_id: @simulation_result.cloudlet_id, cloudlet_length: @simulation_result.cloudlet_length, cloudlet_output_size: @simulation_result.cloudlet_output_size, cloudlet_pes: @simulation_result.cloudlet_pes, cost: @simulation_result.cost, cpu_breach: @simulation_result.cpu_breach, cpu_utilization: @simulation_result.cpu_utilization, datacenter_bw_cost: @simulation_result.datacenter_bw_cost, datacenter_cpu_cost: @simulation_result.datacenter_cpu_cost, datacenter_id: @simulation_result.datacenter_id, datacenter_ram_cost: @simulation_result.datacenter_ram_cost, datacenter_storage_cost: @simulation_result.datacenter_storage_cost, execution_time: @simulation_result.execution_time, execution_time_breach: @simulation_result.execution_time_breach, host_bw: @simulation_result.host_bw, host_cpu_cores: @simulation_result.host_cpu_cores, host_id: @simulation_result.host_id, host_mips: @simulation_result.host_mips, host_ram: @simulation_result.host_ram, host_storage: @simulation_result.host_storage, ram_breach: @simulation_result.ram_breach, ram_utilization: @simulation_result.ram_utilization, sla_breach: @simulation_result.sla_breach, sla_breach_cost: @simulation_result.sla_breach_cost, storage_utilization: @simulation_result.storage_utilization, vm_bw: @simulation_result.vm_bw, vm_cpu_cores: @simulation_result.vm_cpu_cores, vm_id: @simulation_result.vm_id, vm_mips: @simulation_result.vm_mips, vm_ram: @simulation_result.vm_ram, vm_storage: @simulation_result.vm_storage } }
    assert_redirected_to simulation_result_url(@simulation_result)
  end

  test "should destroy simulation_result" do
    assert_difference("SimulationResult.count", -1) do
      delete simulation_result_url(@simulation_result)
    end

    assert_redirected_to simulation_results_url
  end
end
