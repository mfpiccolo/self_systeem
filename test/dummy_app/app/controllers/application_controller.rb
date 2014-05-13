class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :http_auth
  before_action :set_p3p
  before_action :set_time_zone


  def after_sign_in_path_for(resource)
    projects_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  def set_project_access
    @project_access ||= ProjectAccessDeterminator.access user: current_user,
      project: @project,
      organization: @organization
  end

  def project_admin_access?
    set_project_access
    @project_access == :admin
  end
  helper_method :project_admin_access?

  def project_member_access?
    set_project_access
    [:admin, :member].include? @project_access
  end
  helper_method :project_member_access?

  def project_collaborator_access?
    set_project_access
    [:admin, :member, :collaborator].include? @project_access
  end
  helper_method :project_collaborator_access?

  def require_admin_access
    access_denied_redirection unless project_admin_access?
  end

  def require_member_access
    access_denied_redirection unless project_member_access?
  end

  def require_collaborator_access
    access_denied_redirection unless project_collaborator_access?
  end

  def access_denied_redirection
    flash[:error] = "You do not have sufficient privileges to do this action."
      redirect_to([@organization, @project]) && return
  end

  private

  def http_auth
    magicword = "654e00c89410ca8386aabd45"
    if Rails.env.staging? && params[:elb] != magicword
      authenticate_or_request_with_http_basic("finishes-#{Rails.env}") do |u, p|
        u == "finishes" && p == "finishes-#{Rails.env}"
      end
    end
  end

  # IE7 & 8 cross-domain iframe cookie issues
  # http://duanesbrain.blogspot.com/2007/11/facebook-ie-and-iframes.html
  def set_p3p
    response.headers["P3P"]='CP="CAO PSA OUR"'
  end

  def set_time_zone
    Time.zone = "Pacific Time (US & Canada)"
  end

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
      end
    respond_to do |format|
      format.html {
        render file: "#{Rails.root}/public/404.html", status: :not_found,
          layout: false
      }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
end
