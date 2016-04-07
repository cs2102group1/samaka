class CarsController < ApplicationController
  def index
    @cars = Car.find(current_user.email)
  end
  
  def new
    @car = Car.new
  end

  def create
    Car.insert(create_params)
    redirect_to :back
  end

  private

  def create_params
    params.require(:car).permit([:car_plate, :owner])
  end
end