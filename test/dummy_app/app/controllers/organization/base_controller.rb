class Organization::BaseController < ApplicationController
  before_filter :authenticate_user!

  layout "organization"

  def organization_owner?
    @organization.owners.include? current_user
  end
  helper_method :organization_owner?

  def require_organization_owner
    access_denied_redirection unless organization_owner?
  end

end

