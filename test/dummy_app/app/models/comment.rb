# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  finish_id  :integer          not null
#  user_id    :integer          not null
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Comment < ActiveRecord::Base
  belongs_to :finish, counter_cache: true
  belongs_to :user

  validates :finish, presence: true
  validates :user, presence: true
  validates :body, presence: true

  def updated?
    created_at != updated_at
  end

end
