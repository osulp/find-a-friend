class Admin::AdminsController < AdminController
  respond_to :html, :json
  before_filter :find_admin, :only => :destroy

  def index
    @admin = Admin.all
  end
  
  def new
    @admin= Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    flash[:success] = I18n.t("admin.admins.success.creating") if @admin.save
    respond_with @admin, :location => admin_admins_path
  end

  def destroy
    if @admin.destroy
      flash[:success] = I18n.t("admin.admins.success.deleting")
    else
      flash[:error] = I18n.t("admin.admins.error.deleting")
    end
    respond_with [:admin, @admin]
  end

  private

  def admin_params
    params.require(:admin).permit(:onid)
  end
  
  def find_admin
    @admin = Admin.find(params[:id])
  end
end
