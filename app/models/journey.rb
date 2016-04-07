class Journey < ActiveRecord::Base
  def to_param
    {start_time: start_time, car_plate: car_plate}
  end

  def self.all
    query = "SELECT * FROM journeys ORDER BY age(start_time);"
    self.find_by_sql(query)
  end

  def self.find(params)
    query = <<-FIND
            SELECT * FROM journeys j WHERE
            j.car_plate = '#{params[:car_plate]}' AND
            j.start_time = '#{params[:start_time]}';
            FIND
    self.find_by_sql(query)
  end

  def self.insert(params, datetime)
    query = <<-INSERT_J
            INSERT INTO journeys VALUES ('#{params[:pickup_point]}',
              '#{params[:dropoff_point]}',
              '#{params[:price]}',
              '#{params[:available_seats]}',
              '#{params[:car_plate]}',
              '#{datetime}');
            INSERT_J

    self.find_by_sql(query)
    fk_query = <<-INSERT_FK_J
              INSERT INTO drivers (email, start_time, car_plate)
              VALUES ('#{params[:email]}',
              '#{datetime}',
              '#{params[:car_plate]}');
              INSERT_FK_J
    self.find_by_sql(fk_query)
  end

  def self.update(params)
    values = []
    columns = params.keys.each do |k|
      values << "#{k.to_s} = '#{params[k]}'" unless k == 'pickup_point' ||
      k == 'start_time'
    end
    update_values = values.join(',')
    query = <<-UPDATE_J
            UPDATE journeys
            SET #{update_values}
            WHERE pickup_point = '#{params[:pickup_point]}' AND
            start_time = '#{params[:start_time]}';
            UPDATE_J
    self.find_by_sql(query)
  end

  def self.destroy(params)
    tables = ['drivers', 'passengers']
    tables.each do |table|
      fk_query = <<-DELETE_FK_J
              DELETE FROM #{table}
              WHERE start_time = '#{params[:start_time]}' AND
              car_plate = '#{params[:car_plate]}';
              DELETE_FK_J
      self.find_by_sql(fk_query)
    end

    query = <<-DELETE_J
            DELETE FROM journeys
            WHERE pickup_point = '#{params[:pickup_point]}' AND
            start_time = '#{params[:start_time]}'
            DELETE_J
    self.find_by_sql(query)
  end
end
