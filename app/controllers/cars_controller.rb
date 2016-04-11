class CarsController < ApplicationController
  before_action :authenticate_user!
  layout 'subpage'
  def index
    if current_user.admin?
      @cars = Car.all
    else
      @cars = Car.find(owner: current_user.email)
    end
  end

  def new
    @car = Car.new
  end

  def create
    Car.insert(create_params)
    redirect_to :back
  end

  def edit
    @car = Car.find(car_plate: params[:car_plate])
  end

  def update
    Car.update(old: params[:car_plate], new: params[:car][:car_plate], owner: current_user.email)
    redirect_to cars_path
  end

  def destroy
    Car.delete(car_plate: params[:car_plate])
    redirect_to cars_path
  end

  private

  def create_params
    params.require(:car).permit([:car_plate, :owner])
  end
end