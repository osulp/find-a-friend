class Admin::LocationsController < AdminController
  respond_to :html, :json
  before_filter :current_user, :only => [:create, :edit, :update, :destroy]
  before_filter :find_location, :only => [:edit, :update, :destroy]

  def index
    @location = Location.all
    respond_with @location
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      flash[:success] = I18n.t("admin.locations.success.creating")
    else
      flash[:error] = I18n.t("admin.locations.error.creating")
    end
    respond_with @location, :location => admin_locations_path
  end
  
  def edit
  end
  
  def update
    @location.update_attributes(location_params)
    respond_with @location, :location => admin_locations_path
  end

  def destroy
    if @location.destroy
      flash[:success] = I18n.t("admin.locations.success.deleting")
    else
      flash[:error] = I18n.t("admin.locations.error.deleting")
    end
    respond_with [:admin, @location]
  end

  private

  def location_params
    params.require(:location).permit(:location, :photo)
  end

  def find_location
    @location = Location.find(params[:id])
  end
end
