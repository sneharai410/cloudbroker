require 'csv'
class SimulationResultsController < ApplicationController

  before_action :set_simulation_result, only: %i[ show edit update destroy ]

  # GET /simulation_results or /simulation_results.json
  def index
    @simulation_results = SimulationResult.paginate(page: params[:page], per_page: 10)
  end

  # GET /simulation_results/1 or /simulation_results/1.json
  def show
  end

  # GET /simulation_results/new
  def new
    csv_data = CSV.generate(headers: true) do |csv|
      csv << SimulationResult.column_names
      SimulationResult.find_each do |simulation_result|
        csv << simulation_result.attributes.values_at(*SimulationResult.column_names)
      end
  end
  
    send_data csv_data, filename: "simulation_results.csv", type: "text/csv"
  end

  # GET /simulation_results/1/edit
  def edit
  end

  # POST /simulation_results or /simulation_results.json
  def create
    @simulation_result = SimulationResult.new(simulation_result_params)

    respond_to do |format|
      if @simulation_result.save
        format.html { redirect_to @simulation_result, notice: "Simulation result was successfully created." }
        format.json { render :show, status: :created, location: @simulation_result }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @simulation_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /simulation_results/1 or /simulation_results/1.json
  def update
    respond_to do |format|
      if @simulation_result.update(simulation_result_params)
        format.html { redirect_to @simulation_result, notice: "Simulation result was successfully updated." }
        format.json { render :show, status: :ok, location: @simulation_result }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @simulation_result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /simulation_results/1 or /simulation_results/1.json
  def destroy
    @simulation_result.destroy!

    respond_to do |format|
      format.html { redirect_to simulation_results_path, status: :see_other, notice: "Simulation result was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_simulation_result
      @simulation_result = SimulationResult.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def simulation_result_params
      params.require(:simulation_result).permit(:cloudlet_id, :vm_id, :datacenter_id, :execution_time, :cpu_utilization, :ram_utilization, :bw_utilization, :storage_utilization, :cost, :sla_breach, :sla_breach_cost, :cpu_breach, :ram_breach, :bw_breach, :execution_time_breach, :datacenter_cpu_cost, :datacenter_ram_cost, :datacenter_storage_cost, :datacenter_bw_cost, :vm_cpu_cores, :vm_ram, :vm_storage, :vm_bw, :vm_mips, :cloudlet_length, :cloudlet_pes, :cloudlet_file_size, :cloudlet_output_size, :host_id, :host_cpu_cores, :host_ram, :host_storage, :host_bw, :host_mips)
    end
end
