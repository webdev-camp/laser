class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  force_ssl if Rails.env.production?

  def after_sign_in_path_for(resource)
    owners_index_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def require_admin_rights
    redirect_to laser_gems_path unless current_user.admin?
  end

end
