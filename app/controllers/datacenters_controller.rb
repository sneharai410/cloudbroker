class DatacentersController < ApplicationController
  before_action :set_datacenter, only: %i[ show edit update destroy ]

  # GET /datacenters or /datacenters.json
  def index
    @datacenters = Datacenter.all
  end

  # GET /datacenters/1 or /datacenters/1.json
  def show
  end

  # GET /datacenters/new
  def new
    @datacenter = Datacenter.new
  end

  # GET /datacenters/1/edit
  def edit
  end

  # POST /datacenters or /datacenters.json
  def create
    @datacenter = Datacenter.new(datacenter_params)

    respond_to do |format|
      if @datacenter.save
        format.html { redirect_to @datacenter, notice: "Datacenter was successfully created." }
        format.json { render :show, status: :created, location: @datacenter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @datacenter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /datacenters/1 or /datacenters/1.json
  def update
    respond_to do |format|
      if @datacenter.update(datacenter_params)
        format.html { redirect_to @datacenter, notice: "Datacenter was successfully updated." }
        format.json { render :show, status: :ok, location: @datacenter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @datacenter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /datacenters/1 or /datacenters/1.json
  def destroy
    @datacenter.destroy!

    respond_to do |format|
      format.html { redirect_to datacenters_path, status: :see_other, notice: "Datacenter was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_datacenter
      @datacenter = Datacenter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def datacenter_params
      params.require(:datacenter).permit(:name, :num_hosts, :pe_mips, :ram, :storage, :bandwidth, :scheduling_policy, :power_model, :latency, :topology, :bandwidth_policy, :storage_type, :cpu_cost, :ram_cost, :storage_cost, :bw_cost, :power_usage, :idle_power, :autoscaling)
    end
end
