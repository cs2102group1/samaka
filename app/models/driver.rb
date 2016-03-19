class Driver < ActiveRecord::Base
  belongs_to :user
  has_many :journeys, dependent: :destroy

  def self.all
    query = "SELECT * FROM drivers"
    self.find_by_sql(query)
  end

  def self.find(params)
    query = <<-FIND
            SELECT * FROM journeys j WHERE
            j.pickup_point = '#{params[:car_plate]}' AND
            j.start_time = '#{params[:start_time]}';
            FIND
    self.find_by_sql(query);
  end
end
