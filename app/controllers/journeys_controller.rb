class JourneysController < ApplicationController
  before_action :authenticate_user!

  def index
    @journeys = Journey.search(params[:page])
  end

  def new
    @car_plates = current_user.car_plates
    @journey = Journey.new
  end

  def create
    j = params[:journey]
    date = [j['start_time(1i)'], j['start_time(2i)'], j['start_time(3i)']].join('-')
    time = [j['start_time(4i)'], j['start_time(5i)']].join(':')
    datetime = date + ' ' + time
    Journey.insert(create_params, datetime)
    redirect_to :back
  end

  def show
    @journey = Journey.find(find_params)
  end

  def edit
    @journey = Journey.find(find_params).first
  end

  def update
    Journey.update(update_params)
  end

  def destroy
    Journey.destroy(delete_params)
  end

  private

  def create_params
    return nil unless params[:journey]
    permit = [:pickup_point, :dropoff_point, :price, :available_seats,
      :car_plate, :email, :start_time]

    params.require(:journey).permit(permit)
  end

  def update_params
    create_params

    params.permit(permit)
  end

  def find_params
    permit = [:car_plate, :start_time]
    params.permit(permit)
  end

  def delete_params
    permit = [:pickup_point, :start_time, :car_plate]

    params.permit(permit)
  end
end
