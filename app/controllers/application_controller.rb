class ApplicationController < ActionController::Base
  include Authentication
  
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # Removed in development to avoid 406 errors caused by mobile simulations.
  if Rails.env.production?
    allow_browser versions: :modern
  end
end
