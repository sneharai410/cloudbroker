class CloudletsController < ApplicationController
  before_action :set_cloudlet, only: %i[ show edit update destroy ]

  # GET /cloudlets or /cloudlets.json
  def index
    @cloudlets = Cloudlet.all
  end

  # GET /cloudlets/1 or /cloudlets/1.json
  def show
  end

  # GET /cloudlets/new
  def new
    @cloudlet = Cloudlet.new
  end

  # GET /cloudlets/1/edit
  def edit
  end

  # POST /cloudlets or /cloudlets.json
  def create
    @cloudlet = Cloudlet.new(cloudlet_params)

    respond_to do |format|
      if @cloudlet.save
        format.html { redirect_to @cloudlet, notice: "Cloudlet was successfully created." }
        format.json { render :show, status: :created, location: @cloudlet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cloudlet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cloudlets/1 or /cloudlets/1.json
  def update
    respond_to do |format|
      if @cloudlet.update(cloudlet_params)
        format.html { redirect_to @cloudlet, notice: "Cloudlet was successfully updated." }
        format.json { render :show, status: :ok, location: @cloudlet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cloudlet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cloudlets/1 or /cloudlets/1.json
  def destroy
    @cloudlet.destroy!

    respond_to do |format|
      format.html { redirect_to cloudlets_path, status: :see_other, notice: "Cloudlet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cloudlet
      @cloudlet = Cloudlet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cloudlet_params
      params.require(:cloudlet).permit(:length, :file_size, :output_size, :workload_type)
    end
end
