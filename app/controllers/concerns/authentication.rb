module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
    helper_method :current_account
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def current_account
      @current_account ||= Account.find(session[:account_id])
    end

    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || request_authentication
    end

    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      flash[:alert] = "You must be logged in to access this page"
      redirect_to new_session_path
    end

    def after_authentication_url(user)
      after_sign_in_path_for(user)
    end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
      set_account_for(user)
    end

    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
    end

    def set_account_for(user)
      if user.accounts.count == 1
        account = user.accounts.first
        session[:account_id] = account.id
      end
    end

    def after_sign_in_path_for(user)
      if session[:account_id].present?
        session.delete(:return_to_after_authenticating) || root_url
      else
        accounts_selection_path
      end
    end
end
