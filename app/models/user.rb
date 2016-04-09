class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :drivers, dependent: :destroy
  has_many :passengers, dependent: :destroy

  # Constants
  STRING_ROLE_MEMBER = 'member'
  STRING_ROLE_ADMIN  = 'admin'

  before_validation :create_role

  def car_plates
    query = <<-CARPLATES
            SELECT car_plate FROM cars c WHERE
             c.owner = '#{email}';
            CARPLATES
    ActiveRecord::Base.connection.execute(query).values.flatten
  end

  private

  def create_role
    self.role ||= STRING_ROLE_MEMBER
  end
end
