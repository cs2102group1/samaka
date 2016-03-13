class JourneysController < ApplicationController
  def index
    Journey.all
  end

  def new
    @journey = Journey.new
  end

  def create
    Journey.insert(create_params)
  end

  def show
    @journey = Journey.find(show_params)
  end

  def edit
    @journey = Journey.find(show_params)
  end

  def update
    Journey.update(update_params)
  end

  def destroy
    Journey.destroy(show_params)
  end

  private

  def create_params
    return nil unless params[:journey]

    permit [:pickup_point, :dropoff_point, :price, :available_seats,
      :car_plate, :start_time]


    params.require(:journey).permit(permit)
  end

  def update_params
    create_params
  end

  def find_params
    permit [:pickup_point, :start_time]

    params.permit(permit)
  end
end
