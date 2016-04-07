class Passenger < ActiveRecord::Base
  has_many :journeys, dependent: :destroy

  def self.insert(params)
    query = "INSERT INTO passengers (email, start_time, car_plate, onboard) VALUES('#{params[:email]}', '#{params[:start_time]}', '#{params[:car_plate]}', '#{params[:onboard]}');"
    ActiveRecord::Base.connection.execute(query)
  end

  def self.find(params)
    query = <<-FIND
            SELECT * FROM drivers d WHERE
            d.start_time = #{params[:start_time]} AND
            d.car_plate = #{params[:car_plate]}
            FIND
    self.find_by_sql(query)
  end

  def self.update(params, email)
    values = []
    columns = params.keys.each do |k|
      values << "#{k.to_s} = '#{params[k]}'" unless k == 'start_time' ||
      k == 'car_plate'
    end
    update_values = values.join(',')
    query = <<-UPDATE_P
            UPDATE passengers
            SET #{update_values}
            WHERE start_time = '#{params[:start_time]}'
            AND car_plate = '#{params[:car_plate]}'
            AND email = '#{email}'
            UPDATE_P
    ActiveRecord::Base.connection.execute(query)
  end

  def self.check(passenger, j)
    query = "SELECT * FROM passengers WHERE start_time = '#{j.start_time}' AND car_plate = '#{j.car_plate}' AND email = '#{passenger}' AND onboard = TRUE;"
    !ActiveRecord::Base.connection.execute(query).values.empty?
  end
end
