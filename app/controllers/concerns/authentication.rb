module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :load_current_user
    helper_method :current_user, :user_signed_in?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

  def load_current_user
    if session = find_session_by_cookie
      @current_user = session.user
    end
  end

  def current_user
    @current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def require_authentication
    resume_session || request_authentication
  end

  def resume_session
    if session = find_session_by_cookie
      @current_user = session.user
    end
  end

  def find_session_by_cookie
    if id = cookies.signed[:session_id]
      Session.find_by(id: id)
    end
  end

  def request_authentication
    session[:return_to_after_authenticating] = request.url
    redirect_to new_session_path
  end

  def after_authentication_url
    session.delete(:return_to_after_authenticating) || root_path
  end

  def start_new_session_for(user)
    user.sessions.create!(
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    ).tap do |session|
      cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
    end
  end

  def terminate_session
    if current_session = find_session_by_cookie
      current_session.destroy
    end
    cookies.delete(:session_id)
  end
end
