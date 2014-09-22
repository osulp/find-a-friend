class Admin::AboutsController < AdminController
  respond_to :json, :html
  before_filter :find_about, :only => [:edit, :update, :destroy]

  def index
    @abouts = About.all
  end

  def new
    @about = About.new
  end

  def create
    @about = About.new(about_params)
    if @about.save
      flash[:success] = I18n.t("admin.abouts.success.creating")
    else
      flash[:error] = I18n.t("admin.about.error.creating")
    end
    respond_with @about, :location => admin_abouts_path
  end

  def edit
  end

  def update
    @about.update_attributes(about_params)
    respond_with @about, :location => admin_abouts_path
  end

  def destroy
    if @about.destroy
      flash[:success] = I18n.t("admin.about.success.deleting")
    else
      flash[:error] = I18n.t("admin.about.error.deleting")
    end
    respond_with [:admin, @about]
  end

  private

  def about_params
    params.require(:about).permit(:about_text)
  end

  def find_about
    @about = About.find(params[:id])
  end
end
