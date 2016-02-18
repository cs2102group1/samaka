class ChangeCarPlateColumnName < ActiveRecord::Migration
  def change
    rename_column(:journeys, :carplate, :car_plate)
    rename_column(:drivers, :carplate, :car_plate)
    rename_column(:passengers, :carplate, :car_plate)
  end
end
