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


  def self.top_spenders
    query = <<-SPENDER
            SELECT u.username, MAX(j.price)
            FROM users u, passengers p, journeys j
            WHERE u.email = p.email
            AND j.start_time = p.start_time
            AND j.car_plate = p.car_plate
            GROUP BY u.email, u.username
            ORDER BY MAX(j.price) DESC;
            SPENDER
    ActiveRecord::Base.connection.execute(query).values
  end

  def self.frequent_riders
    query = <<-FREQ
            SELECT u.username, COUNT(*)
            FROM users u, passengers p, journeys j
            WHERE u.email = p.email
            AND j.start_time = p.start_time
            AND j.car_plate = p.car_plate
            GROUP BY u.email, u.username
            ORDER BY COUNT(*) DESC;
            FREQ
    ActiveRecord::Base.connection.execute(query).values
  end

  def self.super_drivers
    query = <<-SUDRV
            SELECT u.username, COUNT(*)
            FROM users u, journeys j, drivers d
            WHERE u.email = d.email
            AND j.start_time = d.start_time
            AND j.car_plate = d.car_plate
            GROUP BY u.email, u.username
            ORDER BY COUNT(*) DESC;
            SUDRV
    ActiveRecord::Base.connection.execute(query).values
  end

  def is_admin?
    self.role == STRING_ROLE_ADMIN
  end

  private

  def create_role
    self.role ||= STRING_ROLE_MEMBER
  end
end
