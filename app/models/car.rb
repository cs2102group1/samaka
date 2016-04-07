class Car < ActiveRecord::Base
  def self.insert(params)
    query = "INSERT INTO cars (car_plate, owner)
            VALUES('#{params[:car_plate]}', '#{params[:owner]}');"
    ActiveRecord::Base.connection.execute(query)
  end

  def self.find(options={})
    query = "SELECT car_plate FROM cars c WHERE c.owner = '#{options[:owner]}' OR c.car_plate = '#{options[:car_plate]}';"
    self.find_by_sql(query)
  end

  def self.update(p={})
    Car.delete(car_plate: p[:old])
    ins = "INSERT INTO cars (car_plate, owner) VALUES('#{p[:new]}', '#{p[:owner]}');"
    ActiveRecord::Base.connection.execute(ins)
  end

  def self.delete(p={})
    del = "DELETE FROM cars WHERE car_plate = '#{p[:car_plate]}';"
    ActiveRecord::Base.connection.execute(del)
  end

end