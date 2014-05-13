class OrganizationUserCreator
  attr_reader :organization_user

  def initialize(organization:, user:, role:)
    @organization_user = OrganizationUser.new(organization: organization, user: user, role: role)
  end

  def create
    if organization_user.save
      OrganizationMailer.share(
        organization_user.user_id, organization_user.organization_id
      ).deliver
    end

    organization_user
  end

  def self.create(organization:, user:, role:)
    new(organization: organization, user: user, role: role).create
  end

end
