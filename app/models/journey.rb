class Journey < ActiveRecord::Base
  def self.all
    query = "SELECT * FROM journeys;"
    self.find_by_sql(query)
  end

  def self.find(params)
    query = <<-FIND
            SELECT * FROM journeys j WHERE
            j.pickup_point = '#{params[:pickup_point]}' AND
            j.start_time = '#{params[:start_time]}';
            FIND
    self.find_by_sql(query)
  end

  def self.insert(params)
    query = <<-INSERT_Q
            INSERT INTO journeys VALUES (#{params[:pickup_point]},
              #{params[:dropoff_point]},
              #{params[:price]},
              #{params[:available_seats]},
              #{params[:car_plate]},
              #{params[:start_time]});
            INSERT_Q
    self.find_by_sql(query)
  end

  def self.update(params)
    values = []
    columns = params.key.each do |k|
      values << "#{k.to_s} = '#{params[k].to_s}'" unless k == 'pickup_point' ||
      k == 'start_time'
    end
    update_values = values.join(',')
    query = <<-UPDATE_Q
            UPDATE journeys j
            SET #{update_values}
            WHERE pickup_point = '#{params[:pickup_point]}' AND
            start_time = '#{params[:start_time]}';
            UPDATE_Q
    self.find_by_sql(query)
  end


  def self.destroy(params)
    tables = ['drivers', 'passengers']
    tables.each do |table|
      fk_query = <<-DELETE_Q
              DELETE FROM #{table}
              WHERE start_time = '#{params[:start_time]}' AND
              car_plate = '#{params[:car_plate]}';
              DELETE_Q
      ActiveRecord::Base.connection.execute(fk_query)
    end

    query = <<-DELETE
            DELETE FROM journeys
            WHERE pickup_point = '#{params[:pickup_point]}' AND
            start_time = '#{params[:start_time]}'
            DELETE
    ActiveRecord::Base.connection.execute(query)
  end
end
