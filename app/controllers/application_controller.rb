class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end

  def set_gon
    gon.csrf_token = form_authenticity_token
    gon.user_id = current_user.id
    gon.cluster = ENV['PUSHER_CLUSTER']
  end

end
