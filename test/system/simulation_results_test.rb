require "application_system_test_case"

class SimulationResultsTest < ApplicationSystemTestCase
  setup do
    @simulation_result = simulation_results(:one)
  end

  test "visiting the index" do
    visit simulation_results_url
    assert_selector "h1", text: "Simulation results"
  end

  test "should create simulation result" do
    visit simulation_results_url
    click_on "New simulation result"

    check "Bw breach" if @simulation_result.bw_breach
    fill_in "Bw utilization", with: @simulation_result.bw_utilization
    fill_in "Cloudlet file size", with: @simulation_result.cloudlet_file_size
    fill_in "Cloudlet", with: @simulation_result.cloudlet_id
    fill_in "Cloudlet length", with: @simulation_result.cloudlet_length
    fill_in "Cloudlet output size", with: @simulation_result.cloudlet_output_size
    fill_in "Cloudlet pes", with: @simulation_result.cloudlet_pes
    fill_in "Cost", with: @simulation_result.cost
    check "Cpu breach" if @simulation_result.cpu_breach
    fill_in "Cpu utilization", with: @simulation_result.cpu_utilization
    fill_in "Datacenter bw cost", with: @simulation_result.datacenter_bw_cost
    fill_in "Datacenter cpu cost", with: @simulation_result.datacenter_cpu_cost
    fill_in "Datacenter", with: @simulation_result.datacenter_id
    fill_in "Datacenter ram cost", with: @simulation_result.datacenter_ram_cost
    fill_in "Datacenter storage cost", with: @simulation_result.datacenter_storage_cost
    fill_in "Execution time", with: @simulation_result.execution_time
    check "Execution time breach" if @simulation_result.execution_time_breach
    fill_in "Host bw", with: @simulation_result.host_bw
    fill_in "Host cpu cores", with: @simulation_result.host_cpu_cores
    fill_in "Host", with: @simulation_result.host_id
    fill_in "Host mips", with: @simulation_result.host_mips
    fill_in "Host ram", with: @simulation_result.host_ram
    fill_in "Host storage", with: @simulation_result.host_storage
    check "Ram breach" if @simulation_result.ram_breach
    fill_in "Ram utilization", with: @simulation_result.ram_utilization
    check "Sla breach" if @simulation_result.sla_breach
    fill_in "Sla breach cost", with: @simulation_result.sla_breach_cost
    fill_in "Storage utilization", with: @simulation_result.storage_utilization
    fill_in "Vm bw", with: @simulation_result.vm_bw
    fill_in "Vm cpu cores", with: @simulation_result.vm_cpu_cores
    fill_in "Vm", with: @simulation_result.vm_id
    fill_in "Vm mips", with: @simulation_result.vm_mips
    fill_in "Vm ram", with: @simulation_result.vm_ram
    fill_in "Vm storage", with: @simulation_result.vm_storage
    click_on "Create Simulation result"

    assert_text "Simulation result was successfully created"
    click_on "Back"
  end

  test "should update Simulation result" do
    visit simulation_result_url(@simulation_result)
    click_on "Edit this simulation result", match: :first

    check "Bw breach" if @simulation_result.bw_breach
    fill_in "Bw utilization", with: @simulation_result.bw_utilization
    fill_in "Cloudlet file size", with: @simulation_result.cloudlet_file_size
    fill_in "Cloudlet", with: @simulation_result.cloudlet_id
    fill_in "Cloudlet length", with: @simulation_result.cloudlet_length
    fill_in "Cloudlet output size", with: @simulation_result.cloudlet_output_size
    fill_in "Cloudlet pes", with: @simulation_result.cloudlet_pes
    fill_in "Cost", with: @simulation_result.cost
    check "Cpu breach" if @simulation_result.cpu_breach
    fill_in "Cpu utilization", with: @simulation_result.cpu_utilization
    fill_in "Datacenter bw cost", with: @simulation_result.datacenter_bw_cost
    fill_in "Datacenter cpu cost", with: @simulation_result.datacenter_cpu_cost
    fill_in "Datacenter", with: @simulation_result.datacenter_id
    fill_in "Datacenter ram cost", with: @simulation_result.datacenter_ram_cost
    fill_in "Datacenter storage cost", with: @simulation_result.datacenter_storage_cost
    fill_in "Execution time", with: @simulation_result.execution_time
    check "Execution time breach" if @simulation_result.execution_time_breach
    fill_in "Host bw", with: @simulation_result.host_bw
    fill_in "Host cpu cores", with: @simulation_result.host_cpu_cores
    fill_in "Host", with: @simulation_result.host_id
    fill_in "Host mips", with: @simulation_result.host_mips
    fill_in "Host ram", with: @simulation_result.host_ram
    fill_in "Host storage", with: @simulation_result.host_storage
    check "Ram breach" if @simulation_result.ram_breach
    fill_in "Ram utilization", with: @simulation_result.ram_utilization
    check "Sla breach" if @simulation_result.sla_breach
    fill_in "Sla breach cost", with: @simulation_result.sla_breach_cost
    fill_in "Storage utilization", with: @simulation_result.storage_utilization
    fill_in "Vm bw", with: @simulation_result.vm_bw
    fill_in "Vm cpu cores", with: @simulation_result.vm_cpu_cores
    fill_in "Vm", with: @simulation_result.vm_id
    fill_in "Vm mips", with: @simulation_result.vm_mips
    fill_in "Vm ram", with: @simulation_result.vm_ram
    fill_in "Vm storage", with: @simulation_result.vm_storage
    click_on "Update Simulation result"

    assert_text "Simulation result was successfully updated"
    click_on "Back"
  end

  test "should destroy Simulation result" do
    visit simulation_result_url(@simulation_result)
    click_on "Destroy this simulation result", match: :first

    assert_text "Simulation result was successfully destroyed"
  end
end
