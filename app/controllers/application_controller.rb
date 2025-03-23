class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :force_html_format

  private

  def force_html_format
    request.format = :html if request.format == "*/*"
  end
end
