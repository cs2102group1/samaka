class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :drivers, :passengers, dependent: :destroy

  # Constants
  STRING_ROLE_MEMBER = 'member'
  STRING_ROLE_ADMIN  = 'admin'

  before_validation :create_role

  def self.all
    query = "SELECT * FROM users;"
    self.find_by_sql(query)
  end

  def self.get_user(username)
    query = "SELECT * FROM users WHERE username='#{username}'"
    User.find_by_sql(query)
  end

  def self.update(params)
    values = []
    columns = params.keys.each do |k|
      values << "#{k.to_s} = '#{params[k]}'" unless k == 'email'
    end
    update_values = values.join(',')
    query = <<-UPDATE_U
            UPDATE users
            SET #{update_values}
            WHERE email = '#{params[:email]}';
            UPDATE_U
    self.find_by_sql(query)
  end

  private

  def create_role
    self.role ||= STRING_ROLE_MEMBER
  end
end
