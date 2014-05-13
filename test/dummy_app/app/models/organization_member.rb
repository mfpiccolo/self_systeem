class OrganizationMember
  include ActiveModel::Model

  attr_accessor :email, :name, :role, :organization
  attr_reader :user, :organization_user

  validates :email,    presence: true
  validates :name,     presence: true
  validates :role,     presence: true
  validates :organization,  presence: true

  def save
    return false unless valid? && find_or_create_user

    @organization_user = OrganizationUserCreator.create user: user, organization: organization,
      role: role

    if organization_user.persisted?
      true
    else
      merge_organization_user_errors
      false
    end
  end

  private

  def find_or_create_user
    @user = User.find_by_email(email) ||
      UserCreator.create(name: name, email: email)

    if user.persisted?
      true
    else
      merge_user_errors
      false
    end
  end

  def merge_user_errors
    user.errors[:email].each { |error| errors.add :email, error }
    user.errors[:name].each  { |error| errors.add :name, error }
  end

  def merge_organization_user_errors
    if organization.users.include? user
      errors.add :email, "appears to already be associated to organization."
    end

    organization_user.errors[:role].each do |error|
      errors.add :role, error
    end
  end

end
