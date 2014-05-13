class OrganizationCreator
  attr_reader :user
  attr_reader :organization

  def initialize(user:, name:, location: nil, description: nil)
    @user = user
    @organization = Organization.new(
      name: name,
      location: location,
      description: description
    )
  end

  def create
    ActiveRecord::Base.transaction do
      if organization.save
        OrganizationUser.create(
          user: user, organization: organization, role: "owner"
        )
        DefaultAreaSeeder.seed(organization)
        DefaultCategorySeeder.seed(organization)
      end
    end

    organization
  end

  def self.create(user:, name:, location: nil, description: nil)
    new(user: user, name: name, location: location, description: description).create
  end

end
