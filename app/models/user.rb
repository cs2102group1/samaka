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

  def self.all
    query = "SELECT * FROM users;"
    self.find_by_sql(query)
  end

  def self.get_user(username, email)
    query = "SELECT * FROM users WHERE username='#{username}'"
    self.find_by_sql(query)
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

  def self.delete(params)
    journeys = []
    driver_query = <<-USER_DRIVER
                  SELECT start_time, car_plate FROM drivers
                  WHERE email = '#{params[:email]}';
                  USER_DRIVER
    passenger_query = <<-USER_PSSNGR
                  SELECT start_time, car_plate FROM passengers
                  WHERE email = '#{params[:email]}';
                  USER_PSSNGR

    driver_journeys = self.find_by_sql(driver_query)
    self.find_by_sql("DELETE FROM drivers
                      WHERE email = '#{params[:email]}';")

    passenger_journeys = self.find_by_sql(passenger_query)
    self.find_by_sql("DELETE FROM passengers
                      WHERE email = '#{params[:email]}';")

    driver_journeys.each do |u|
      self.find_by_sql("DELETE FROM passengers
                       WHERE start_time = '#{u.start_time}' AND
                       car_plate = '#{u.car_plate}';")
      self.find_by_sql("DELETE FROM journeys
                       WHERE start_time = '#{u.start_time}' AND
                       car_plate = '#{u.car_plate}';")
    end

    passenger_journeys.each do |u|
      self.find_by_sql("DELETE FROM drivers
                       WHERE start_time = '#{u.start_time}' AND
                       car_plate = '#{u.car_plate}';")
      self.find_by_sql("DELETE FROM journeys
                       WHERE start_time = '#{u.start_time}' AND
                       car_plate = '#{u.car_plate}';")
    end

    user_query = "DELETE FROM users WHERE email = '#{params[:email]}';"
    self.find_by_sql(user_query);
  end

  private

  def create_role
    self.role ||= STRING_ROLE_MEMBER
  end
end
