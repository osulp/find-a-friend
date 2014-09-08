class LocationController < ApplicationController
  respond_to :html, :json
  before_filter :current_user, :only => [:create, :edit, :update, :destroy]
  before_filter :find_location, :only => [:edit, :update, :destroy]

  def index
    @location = Location.all
  end
  def new
    @location = Location.new
  end
  def create
    @location = Location.new(location_params)
    if @location.save
      flash[:success] = "Successfully added location"
    else
      flash[:error] = "There was an error in adding the location. Please try again later."
    end
  end
  def edit
  end
  def update
    @location.update_attributes(location_params)
    respond_with @location, :location => root_path
  end
  def destroy
    if @location.destroy
      flash[:success] = "Location destroyed"
    else
      flash[:error] = "There was an error in deleting the location. Please try again later."
    end
    respond_with @location
  end

  private

  def location_params
    params.require(:location).permit(:location)
  end
  def find_location
    @location = Location.find(params[:id])
  end
end
