class UserCreator
  attr_reader :user


  def initialize(email:, name:, password: SecureRandom.uuid)
    @user = User.new(email: email, name: name, password: password)
  end

  def create
    if user.save
      UserInvitor.call(user)
    end
    user
  end

  def self.create(email:, name:, password: SecureRandom.uuid)
    new(email: email, name: name, password: password).create
  end

end
