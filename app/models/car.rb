class Car < ActiveRecord::Base
  belongs_to :user
  def self.insert(params)
    query = "INSERT INTO cars (car_plate, owner)
            VALUES('#{params[:car_plate]}', '#{params[:owner]}');"
    ActiveRecord::Base.connection.execute(query)
  end

  def self.find(user_email)
    query = "SELECT car_plate FROM cars c WHERE c.owner = '#{user_email}';"
    self.find_by_sql(query)
  end
end