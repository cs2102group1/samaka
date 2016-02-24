class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Constants
  STRING_ROLE_MEMBER = 'member'
  STRING_ROLE_ADMIN  = 'admin'

  before_validation :create_role

  private

  def create_role
    self.role ||= STRING_ROLE_MEMBER
  end
end
