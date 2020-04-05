class ApplicationController < ActionController::Base
  include TheRole::Controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery
  
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_current_location, :unless => :devise_controller?

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  rescue_from ActiveRecord::RecordNotFound do
    flash[:warning] = 'Resource not found.'
    redirect_back_or root_path
  end

  def redirect_back_or(path)
    redirect_to request.referer || path
  end
  
protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

private

  def store_current_location
    store_location_for(:user, request.url)
  end
  
  def after_sign_out_path_for(resource)
    request.referrer || root_path
  end
  
end
