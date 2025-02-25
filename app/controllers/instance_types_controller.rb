class InstanceTypesController < ApplicationController
  def index
    @instance_types = InstanceType.all
  end

  def show
  end

  def new
  end

  def edit
  end
end
