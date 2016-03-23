class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :journeys, dependent: :destroy

  def self.all
    query = "SELECT * FROM drivers"
    self.find_by_sql(query)
  end

  def self.find(params)
    query = <<-FIND
            SELECT * FROM drivers d WHERE
            d.start_time = #{params[:start_time]} AND
            d.car_plate = #{params[:car_plate]}
            FIND
    self.find_by_sql(query)
  end

  def self.update(params)
    values = []
    columns = params.keys.each do |k|
      values << "#{k.to_s} = '#{params[k]}'" unless k == 'start_time' ||
      k == 'car_plate'
    end
    update_values = values.join(',')
    query = <<-UPDATE_D
            UPDATE drivers
            SET #{update_values}
            WHERE start_time = #{params[:start_time]}
            AND car_plate = #{params[:car_plate]}
            UPDATE_D
  end
end
