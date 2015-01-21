class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  protected

  def current_user
    @current_user ||= cas_username
  end
  helper_method :current_user

  def admin?(subject)
    Admin.where(:onid => subject).count > 0
  end
  helper_method :admin?

  private

  def cas_username
    session[RubyCAS::Filter.client.username_session_key]
  end
end
