class Passenger < ActiveRecord::Base
  has_many :journeys, dependent: :destroy

  def self.insert(params)
    journey = {start_time: params[:start_time], car_plate: params[:car_plate]}
    if self.check(params[:email], journey, 'false')
      self.update({onboard: true, start_time: params[:start_time], car_plate: params[:car_plate]}, params[:email])
      return
    end

    query = "INSERT INTO passengers (email, start_time, car_plate, onboard) VALUES('#{params[:email]}', '#{params[:start_time]}', '#{params[:car_plate]}', '#{params[:onboard]}');"
    ActiveRecord::Base.connection.execute(query)

    reduce_avail = <<-REDUC
               UPDATE journeys
               SET available_seats = available_seats - 1
               WHERE start_time = '#{params[:start_time]}'
               AND car_plate = '#{params[:car_plate]}'
               REDUC
    ActiveRecord::Base.connection.execute(reduce_avail)
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
    did_join = params[:onboard] == 'false' ? 1 : -1
    reduce_avail = <<-REDUC
                   UPDATE journeys
                   SET available_seats = available_seats + #{did_join}
                   WHERE start_time = '#{params[:start_time]}'
                   AND car_plate = '#{params[:car_plate]}'
                   REDUC
    ActiveRecord::Base.connection.execute(reduce_avail)
  end

  def self.check(passenger, j, cond)
    query = "SELECT * FROM passengers WHERE start_time = '#{j[:start_time]}' AND car_plate = '#{j[:car_plate]}' AND email = '#{passenger}' AND onboard = #{cond};"
    !ActiveRecord::Base.connection.execute(query).values.empty?
  end
end
