class ProjectMember
  include ActiveModel::Model

  attr_accessor :email, :name, :role, :project
  attr_reader :user, :project_user

  validates :email,    presence: true
  validates :name,     presence: true
  validates :role,     presence: true
  validates :project,  presence: true

  def save
    return false unless valid? && find_or_create_user

    @project_user = ProjectUserCreator.create user: user, project: project,
      role: role

    if project_user.persisted?
      true
    else
      merge_project_user_errors
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

  def merge_project_user_errors
    if project.users.include? user
      errors.add :email, "appears to already be associated to project."
    end

    project_user.errors[:role].each do |error|
      errors.add :role, error
    end
  end

end
