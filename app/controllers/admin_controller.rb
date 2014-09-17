class AdminController < ApplicationController
  before_filter :require_admin

  def index
  end

  private

  def require_admin
    render :status => :unauthorized, :text => I18n.t("permission_error.error_string") unless current_user && admin?(current_user)
  end
end
