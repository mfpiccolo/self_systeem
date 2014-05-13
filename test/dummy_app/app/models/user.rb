# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  invitation_token       :string(255)
#  name                   :string(255)      not null
#

class User < ActiveRecord::Base
  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :organization_users, dependent: :destroy
  has_many :organizations, through: :organization_users
  has_many :selections, class_name: Finish, foreign_key: "selected_by_id",
    dependent: :nullify
  has_many :comments, dependent: :destroy

  validates :name, presence: true, length: { maximum: 255 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def set_invitation_token!
    self.invitation_token = SecureRandom.uuid
    save!
  end

  def clear_invitation_token!
    self.invitation_token = nil
    save!
  end

end
