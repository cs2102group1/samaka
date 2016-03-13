class Journey < ActiveRecord::Base
  def self.all
    ActiveRecord::Base.connection.execute("SELECT * FROM journeys;")
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
    query = <<-INSERT
            INSERT INTO journeys VALUES (#{params[:pickup_point]},
              #{params[:dropoff_point]},
              #{params[:price]},
              #{params[:available_seats]},
              #{params[:car_plate]},
              #{params[:start_time]});
            INSERT
    self.find_by_sql(query)
  end

  def self.update(params)
    values = []
    columns = params.key.each do |k|
      values << "#{k.to_s} = '#{params[k].to_s}'" unless k == 'pickup_point' ||
      k == 'start_time'
    end
    update_values = values.join(',')
    query = <<-UPDATE journeys j
            SET #{update_values}
            WHERE pickup_point = #{params[pickup_point]} AND
            start_time = #{params[start_time]}
            UPDATE
    self.find_by_sql(query)
    end


  def self.destroy(params)
    query = <<-DELETE FROM journeys j
            WHERE pickup_point = #{params[pickup_point]} AND
            start_time = #{params[start_time]}
            DELETE
    self.find_by_sql(query)
  end
end
