class JourneysController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:q]
      @journeys = Journey.filter(params[:q], current_user.email)
    else
      @journeys = Journey.all
    end
  end

  def new
    @car_plates = current_user.car_plates
    @journey = Journey.new
  end

  def create
    Journey.insert(create_params, get_datetime(params[:journey]))
    redirect_to :back
  end

  def show
    @journey = Journey.find(find_params)
  end

  def edit
    @journey = Journey.find(find_params).first
  end

  def update
    Journey.update(update_params, get_datetime(params[:journey]))
    redirect_to journeys_path
  end

  def destroy
    Journey.destroy(delete_params)
    redirect_to :back
  end

  private

  def create_params
    return nil unless params[:journey]
    permit = [:pickup_point, :dropoff_point, :price, :available_seats,
      :car_plate, :email, :start_time]

    params.require(:journey).permit(permit)
  end

  def update_params
    permit = [:pickup_point, :dropoff_point, :price, :available_seats,
      :car_plate, :email]

    params.require(:journey).permit(permit)
  end

  def find_params
    permit = [:car_plate, :start_time]
    params.permit(permit)
  end

  def delete_params
    permit = [:pickup_point, :start_time, :car_plate]

    params.permit(permit)
  end

  def get_datetime(j)
    date = [j['start_time(1i)'], j['start_time(2i)'], j['start_time(3i)']].join('-')
    time = [j['start_time(4i)'], j['start_time(5i)']].join(':')
    datetime = date + ' ' + time
  end
end
